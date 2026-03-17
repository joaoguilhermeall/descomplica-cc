"""
AWS Lambda Function: Temperature Converter with Weather Integration
Converts temperatures between Celsius, Fahrenheit, and Kelvin.
When no input is provided, fetches current temperature from Belo Horizonte, Brazil.
"""

import json
import os
from urllib.request import urlopen, Request, URLError
from urllib.error import HTTPError


def get_belo_horizonte_temperature():
    """
    Fetch current temperature in Belo Horizonte from Open-Meteo API.

    Returns:
        float: Temperature in Celsius, or None if API call fails
    """
    # Belo Horizonte coordinates
    latitude = os.environ.get('BH_LATITUDE', '-19.9167')
    longitude = os.environ.get('BH_LONGITUDE', '-43.9333')
    api_url = os.environ.get('WEATHER_API_URL', 'https://api.open-meteo.com/v1/forecast')

    url = f"{api_url}?latitude={latitude}&longitude={longitude}&current=temperature_2m&temperature_unit=celsius"

    try:
        # Create request with timeout
        request = Request(url)
        request.add_header('User-Agent', 'AWS-Lambda-Temperature-Converter/1.0')

        # Make API call with 5-second timeout
        with urlopen(request, timeout=5) as response:
            if response.status != 200:
                print(f"Weather API returned status {response.status}")
                return None

            data = json.loads(response.read().decode('utf-8'))
            temperature = data['current']['temperature_2m']
            print(f"Successfully fetched Belo Horizonte temperature: {temperature}°C")
            return float(temperature)

    except HTTPError as e:
        print(f"HTTP Error fetching weather data: {e.code} - {e.reason}")
        return None
    except URLError as e:
        print(f"URL Error fetching weather data: {e.reason}")
        return None
    except KeyError as e:
        print(f"Unexpected API response structure: missing key {e}")
        return None
    except (json.JSONDecodeError, ValueError) as e:
        print(f"Error parsing weather API response: {e}")
        return None
    except Exception as e:
        print(f"Unexpected error fetching weather data: {e}")
        return None


def celsius_to_fahrenheit(celsius):
    """Convert Celsius to Fahrenheit."""
    return (celsius * 9/5) + 32


def celsius_to_kelvin(celsius):
    """Convert Celsius to Kelvin."""
    return celsius + 273.15


def create_response(status_code, body, cors=True):
    """
    Create standardized API Gateway response.

    Args:
        status_code: HTTP status code
        body: Response body (will be JSON encoded)
        cors: Whether to include CORS headers

    Returns:
        dict: Formatted response for API Gateway
    """
    headers = {
        'Content-Type': 'application/json'
    }

    if cors:
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Content-Type'

    return {
        'statusCode': status_code,
        'headers': headers,
        'body': json.dumps(body, ensure_ascii=False)
    }


def lambda_handler(event, context):
    """
    AWS Lambda handler function for temperature conversion.

    Args:
        event: API Gateway event containing request data
        context: Lambda context object

    Returns:
        dict: API Gateway response with temperature conversions
    """
    print(f"Received event: {json.dumps(event)}")

    # Handle OPTIONS requests for CORS preflight
    if event.get('requestContext', {}).get('http', {}).get('method') == 'OPTIONS':
        return create_response(200, {'message': 'OK'})

    # Extract query parameters
    query_params = event.get('queryStringParameters')
    celsius_input = None
    source = None

    # Check if celsius parameter was provided
    if query_params and 'celsius' in query_params:
        try:
            celsius_input = float(query_params['celsius'])
            source = 'input'
            print(f"Using input temperature: {celsius_input}°C")
        except (ValueError, TypeError):
            return create_response(400, {
                'error': 'Invalid temperature value',
                'message': 'The celsius parameter must be a valid number',
                'example': '/convert?celsius=25'
            })
    else:
        # No input provided, fetch current temperature from Belo Horizonte
        print("No celsius parameter provided, fetching Belo Horizonte weather...")
        celsius_input = get_belo_horizonte_temperature()

        if celsius_input is None:
            return create_response(503, {
                'error': 'Weather service unavailable',
                'message': 'Unable to fetch current temperature from Belo Horizonte. Please provide a celsius parameter.',
                'example': '/convert?celsius=25'
            })

        source = 'belo_horizonte'

    # Perform temperature conversions
    try:
        fahrenheit = celsius_to_fahrenheit(celsius_input)
        kelvin = celsius_to_kelvin(celsius_input)

        response_body = {
            'source': source,
            'temperature': {
                'celsius': round(celsius_input, 2),
                'fahrenheit': round(fahrenheit, 2),
                'kelvin': round(kelvin, 2)
            }
        }

        if source == 'belo_horizonte':
            response_body['location'] = {
                'city': 'Belo Horizonte',
                'state': 'Minas Gerais',
                'country': 'Brazil',
                'coordinates': {
                    'latitude': -19.9167,
                    'longitude': -43.9333
                }
            }

        print(f"Conversion successful: {json.dumps(response_body)}")
        return create_response(200, response_body)

    except Exception as e:
        print(f"Error during temperature conversion: {e}")
        return create_response(500, {
            'error': 'Internal server error',
            'message': 'An unexpected error occurred during temperature conversion'
        })
