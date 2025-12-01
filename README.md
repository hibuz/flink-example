# A Flink application project using Java and Gradle.


## Building and running
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

Visit dashboard : http://localhost:8081
![Flink Dashboard](.assets/image.png)

### References
- https://nightlies.apache.org/flink/flink-docs-stable/