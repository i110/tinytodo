# tinytodo
This repository is created for showing that H2O's mruby handler is not the bottleneck of the whole system.
I assumed that H2O and nginx works as a reverse-proxy which delegate requests to an upstream app (app/app.psgi),
and what they only do is some (little-bit complicated) Access Control.

Before running the benchmark, I supposed that the performance of H2O's Access Control itself would be worse than
nginx due to it's mruby overhead, but the result was not what I expected..

## H2O configuration
https://github.com/i110/tinytodo/blob/master/conf/h2o.conf

## nginx configuration
https://github.com/i110/tinytodo/blob/master/conf/nginx.conf

## run the benchmark

```
 wrk -t36 -c180 -d10 -s wrk.lua http://$REVPROXY:5001/
```
