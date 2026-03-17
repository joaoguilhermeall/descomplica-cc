variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
  default     = "us-east-1"
}

variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "temperature-converter"
}

variable "python_runtime" {
  description = "Python runtime version for Lambda"
  type        = string
  default     = "python3.12"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 10
}

variable "lambda_memory" {
  description = "Lambda function memory allocation in MB"
  type        = number
  default     = 128
}

variable "weather_api_url" {
  description = "Base URL for weather API (Open-Meteo)"
  type        = string
  default     = "https://api.open-meteo.com/v1/forecast"
}

variable "bh_latitude" {
  description = "Latitude of Belo Horizonte, Brazil"
  type        = string
  default     = "-19.9167"
}

variable "bh_longitude" {
  description = "Longitude of Belo Horizonte, Brazil"
  type        = string
  default     = "-43.9333"
}
