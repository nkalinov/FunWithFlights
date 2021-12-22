resource "aws_dynamodb_table" "routes" {
  hash_key     = "provider_airline_sourceAirport_destinationAirport"
  name         = "routes"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "provider_airline_sourceAirport_destinationAirport"
    type = "S"
  }
  #  attribute {
  #    name = "codeShare"
  #    type = "S"
  #  }
  #  attribute {
  #    name = "stops"
  #    type = "N"
  #  }
  #  attribute {
  #    name = "equipment"
  #    type = "S"
  #  }
}

resource "aws_dynamodb_table" "providers" {
  hash_key     = "id"
  name         = "providers"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}