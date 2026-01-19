# Apache Flink Usecases on modern data lakehouse
This repository contains examples of using Apache Flink and Apache Iceberg for real-time data processing and analytics on modern data lakehouse architectures.

## 🛡️ Flink example: Fraud Detection
Demonstrates a simple fraud detection application using Apache Flink. The application reads a stream of transactions, identifies potentially fraudulent activities based on predefined criteria, and outputs alerts for further investigation.

### Building and running
To run and test your application with an embedded instance of Flink
```bash
./gradlew run

# Sample Output
04:46:51,857 INFO  org.apache.flink.runtime.executiongraph.ExecutionGraph       [] - fraud-detector -> Sink: send-alerts (1/2) (783f...e791_0_0) switched from INITIALIZING to RUNNING.
04:46:54,678 INFO  org.apache.flink.walkthrough.common.sink.AlertSink           [] - Alert{id=3}
04:46:59,687 INFO  org.apache.flink.walkthrough.common.sink.AlertSink           [] - Alert{id=3}
04:47:04,701 INFO  org.apache.flink.walkthrough.common.sink.AlertSink           [] - Alert{id=3}
<=========----> 75% EXECUTING 14s]
> :run
```
To package your job for submission to Flink,
```bash
./gradlew shadowJar
```
Afterwards, you'll find the jar to use in the 'build/libs' folder.

To run in cluster mode
```bash
flink run build/libs/*-all.jar
```

## 🔗 Real-time Data Pipeline
Ingest data from an OLTP MySQL database using the Flink CDC connector, process it in real time with Flink Streaming, and store the results in an Apache Iceberg open table format lakehouse on S3-compatible MinIO object storage.

### Prerequisites
```bash
# Clone the repository
git clone https://github.com/hibuz/kafka-all-in-one.git

# Start mysql service
cd kafka-all-in-one
docker compose up mysql -d

# Verify all services are running
docker exec mysql mysql -umyuser -pmyuser_pw123! -Dmysqldb -e "select * from products;"
mysql: [Warning] Using a password on the command line interface can be insecure.
id      sku     name    description     weight  price   create_at
1       P-001   scooter Small 2-wheel scooter   3.14    10.224  2026-01-19 18:02:24
2       P-002   car battery     12V car battery 8.1     11.224  2026-01-19 18:02:24
...
```

## Visit dashboard : http://localhost:8081
![Flink Dashboard](.assets/image.png)

## References
- https://nightlies.apache.org/flink/flink-docs-stable/