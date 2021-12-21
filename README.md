# FunWithFlights

Todo:

- [x] POC of a Node+TS microservice
    - [x] CI/CD through GitHub Actions
- [x] POC of public website (`web-main`) with Next export
    - [x] CI/CD through GitHub Actions
- [x] Application Load Balancer with /api/data binding for data service
- [x] S3 bucket hosting `web-main` website
- [x] Cloudfront distribution to expose main website and ALB
- [ ] Second POC service + Route53 Private Hosted Zone for intracommunication
- [ ] Cache calls in /api/data/routes using ElastiCache
- [ ] Lambda to fetch flight data and pump to Kinesis
- [ ] DynamoDB with Kinesis streaming
- [ ] Consume Dynamo from data-service
  