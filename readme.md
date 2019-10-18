# Simple EFK Test
## Overview ##

This branch is being used to test nanosecond preceision in a simple docker-compose test.

To run, just clone this repo then execute the `./start.sh` script.
You can then go to http://localhost:9200 in your browser and see the log messages from a `DCOrder` container (Yes, it will fail to start - I just want our logs).

To confirm it is working, go to the Kibana UI and add a filter to only view the **component-simulator** messages - you will see that the log entries, *Lines 1-1000* are in correct order.

```
        #fluentd-sub-second-precision: "true"
```

Then run `./start.sh` again and filter the kibana UI by the **component-simulator** container and you will see the log lines are not in order.

# TO DO 
Although docker will send the `@timestamp` in nanosecond precision, I don't think older versions of Kibana/Elastic will honor that, so it will probable still show out of order, but when you drill into a message and look at the json tab, I suspect it will show full resolution.  

We need to test with 6.3 and 2.4 versions of ES and Kibana.