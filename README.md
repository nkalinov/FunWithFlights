# FunWithFlights

### https://dsi7c8mewu9pm.cloudfront.net/

![alt text](./docs/infra.png?raw=true)

### Progress

- [x] POC of a Node+TS microservice.
  - [x] CI/CD through GitHub Actions.
- [x] POC of public website (`web-main`) with Next export.
  - [x] S3 bucket for website hosting.
  - [x] CI/CD through GitHub Actions.
- [x] Application Load Balancer with /api/data binding for data service.
- [x] Cloudfront distribution
  - [x] Expose main website (S3 origin)
  - [x] Expose the ALB under `/api/*`
  - [ ] Revisit cache rules and invalidate on deploy.
- [ ] Dynamo setup
  - [ ] `Providers` table
  - [ ] `Routes_$Provider` table
  - [ ] `Routes` aggregated table
  - [ ] DAX
- [ ] Scheduled Lambda to fetch flight data and pump to Kinesis.
- [ ] Consume Dynamo from data-service (with DAX).
- [ ] Second POC service + Route53 Private Hosted Zone for intracommunication.
- [ ] Cognito
