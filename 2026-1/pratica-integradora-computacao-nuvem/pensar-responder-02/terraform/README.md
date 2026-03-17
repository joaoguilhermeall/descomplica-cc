# Temperature Converter - Terraform Deployment

This directory contains Terraform configuration for deploying the Temperature Converter AWS Lambda function with API Gateway integration.

## Architecture

The infrastructure creates:
- **AWS Lambda Function**: Python 3.12 runtime with temperature conversion logic
- **API Gateway HTTP API**: Public REST endpoint
- **IAM Role**: Execution role with CloudWatch Logs permissions
- **CloudWatch Log Groups**: For Lambda and API Gateway logs

## Prerequisites

Before deploying, ensure you have:

1. **Terraform installed** (version >= 1.0)
   ```bash
   terraform version
   ```

2. **AWS CLI configured** with valid credentials
   ```bash
   aws configure
   # Enter your AWS Access Key ID, Secret Access Key, and Region
   ```

3. **Sufficient AWS permissions** to create:
   - Lambda functions
   - API Gateway resources
   - IAM roles and policies
   - CloudWatch Log Groups

## Deployment Steps

### 1. Initialize Terraform

Navigate to the terraform directory and initialize the providers:

```bash
cd terraform
terraform init
```

This downloads the required AWS and Archive providers.

### 2. Review the Plan

Preview the resources that will be created:

```bash
terraform plan
```

Review the output to ensure all resources are correct.

### 3. Deploy Infrastructure

Apply the Terraform configuration:

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

The deployment typically takes 30-60 seconds.

### 4. Get API Endpoint

After successful deployment, get the API endpoint URL:

```bash
terraform output api_endpoint
```

Or see all outputs:

```bash
terraform output
```

## Testing the API

### Test with Specific Temperature

Convert 25°C to Fahrenheit and Kelvin:

```bash
curl "$(terraform output -raw api_endpoint)?celsius=25"
```

Expected response:
```json
{
  "source": "input",
  "temperature": {
    "celsius": 25.0,
    "fahrenheit": 77.0,
    "kelvin": 298.15
  }
}
```

### Test with Belo Horizonte Weather

Get current temperature from Belo Horizonte:

```bash
curl "$(terraform output -raw api_endpoint)"
```

Expected response:
```json
{
  "source": "belo_horizonte",
  "temperature": {
    "celsius": 23.5,
    "fahrenheit": 74.3,
    "kelvin": 296.65
  },
  "location": {
    "city": "Belo Horizonte",
    "state": "Minas Gerais",
    "country": "Brazil",
    "coordinates": {
      "latitude": -19.9167,
      "longitude": -43.9333
    }
  }
}
```

### Test Error Handling

Try with invalid input:

```bash
curl "$(terraform output -raw api_endpoint)?celsius=invalid"
```

## Viewing Logs

### Lambda Logs

View Lambda execution logs in real-time:

```bash
aws logs tail /aws/lambda/temperature-converter --follow
```

Or using Terraform output:

```bash
aws logs tail $(terraform output -raw cloudwatch_log_group) --follow
```

### API Gateway Logs

```bash
aws logs tail /aws/apigateway/temperature-converter-api --follow
```

## Updating the Infrastructure

If you modify the Lambda code or Terraform configuration:

1. **Review changes**:
   ```bash
   terraform plan
   ```

2. **Apply updates**:
   ```bash
   terraform apply
   ```

Terraform will automatically detect changes and update only the necessary resources.

## Cleanup

To destroy all created resources and avoid AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm deletion.

**Warning**: This will permanently delete:
- Lambda function
- API Gateway
- IAM roles
- CloudWatch Log Groups and all logs

## Customization

### Change AWS Region

Edit `variables.tf` or override at runtime:

```bash
terraform apply -var="aws_region=sa-east-1"
```

### Adjust Lambda Configuration

Modify in `variables.tf`:
- `lambda_timeout`: Execution timeout (default: 10 seconds)
- `lambda_memory`: Memory allocation (default: 128 MB)
- `function_name`: Lambda function name

### Change Weather Location

To fetch weather from a different city, update coordinates in `variables.tf`:

```hcl
variable "bh_latitude" {
  default = "YOUR_LATITUDE"
}

variable "bh_longitude" {
  default = "YOUR_LONGITUDE"
}
```

## Troubleshooting

### Lambda Timeout Errors

If weather API is slow, increase timeout:

```bash
terraform apply -var="lambda_timeout=15"
```

### Permission Denied

Ensure your AWS credentials have necessary permissions:

```bash
aws sts get-caller-identity
```

### API Returns 503

Weather API may be temporarily unavailable. Check Lambda logs:

```bash
aws logs tail /aws/lambda/temperature-converter --follow
```

Try providing explicit temperature parameter:

```bash
curl "$(terraform output -raw api_endpoint)?celsius=20"
```

## Cost Estimation

All resources are within AWS Free Tier:
- **Lambda**: 1M requests/month free
- **API Gateway**: 1M requests/month free (HTTP API)
- **CloudWatch Logs**: 5 GB ingestion/month free

Expected cost for moderate use: **$0.00/month**

## Files

- `main.tf`: Main infrastructure resources
- `variables.tf`: Input variables and defaults
- `outputs.tf`: Output values after deployment
- `README.md`: This file
- `lambda_function.zip`: Auto-generated Lambda deployment package

## Support

For issues or questions, refer to:
- AWS Lambda Documentation: https://docs.aws.amazon.com/lambda/
- Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/
- Open-Meteo API: https://open-meteo.com/
