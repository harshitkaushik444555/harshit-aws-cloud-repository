What is CloudWatch?
```
-a service which is watching activities on cloud
-CloudWatch is a gatekeeper for your aws account which will help in understanding and monitoring, alerting, reporting, logging. Using these features you can keep track of activities happening on your aws account.
-AWS CloudWatch is a powerful monitoring and observability service provided by Amazon Web Services. It enables you to gain insights into the performance, health, and operational aspects of your AWS resources and applications. CloudWatch collects and tracks metrics, collects and monitors log files, and sets alarms to alert you on certain conditions.
```
On high level what are advantages of cloud watch?
Comprehensive Monitoring: CloudWatch allows you to monitor various AWS resources such as EC2 instances, RDS databases, Lambda functions, and more. You get a unified view of your entire AWS infrastructure.
Real-Time Metrics: It provides real-time monitoring of metrics, allowing you to respond quickly to any issues or anomalies that might arise.
Automated Actions: With CloudWatch Alarms, you can set up automated actions like triggering an Auto Scaling group to scale in or out based on certain conditions.
Log Insights: CloudWatch Insights lets you analyze and search log data from various AWS services, making it easier to troubleshoot problems and identify trends.
Dashboards and Visualization: Create custom dashboards to visualize your application and infrastructure metrics in one place, making it easier to understand the overall health of your system.

What problems cloudwatch solves?
Resource Utilization: Tracking resource utilization and performance metrics to optimize your AWS infrastructure efficiently.
Proactive Monitoring: Identifying and resolving issues before they impact your applications or users.
Troubleshooting: Analyzing logs and metrics to troubleshoot problems and reduce downtime.
Scalability: Automatically scaling resources based on demand to ensure optimal performance and cost efficiency.

What are practical use cases of cloudwatch?
Auto Scaling: CloudWatch can trigger Auto Scaling actions based on defined thresholds. For example, you can automatically scale in or out based on CPU utilization or request counts.
Resource Monitoring: Monitor EC2 instances, RDS databases, DynamoDB tables, and other AWS resources to gain insights into their performance and health.
Application Insights: Track application-specific metrics to monitor the performance of your applications and identify potential bottlenecks.
Log Analysis: Use CloudWatch Logs Insights to analyze log data, identify patterns, and troubleshoot issues in real-time.
Billing and Cost Monitoring: CloudWatch can help you monitor your AWS billing and usage patterns, enabling you to optimize costs.

What is metric?
A metric represents a time-ordered set of data points that are published to CloudWatch. Think of a metric as a variable to monitor, and the data points as representing the values of that variable over time.

What does time-ordered means in metrics?
"time-ordered" means that each data point in a metric is recorded with a specific timestamp in sequential order. This creates a timeline or sequence of events, so you can track how a metric changes over time.

What is time stamp?
Each metric data point must be associated with a time stamp. The time stamp can be up to two weeks in the past and up to two hours into the future. If you do not provide a time stamp, CloudWatch creates a time stamp for you based on the time the data point was received.

What are log group?
Cloud watch automatically creates a groups for your logs which are called log groups. For each project it will create a log group.
