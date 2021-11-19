# Example app

## Reaching the app from external
There is an Istio gateway called `main-gateway` in the `istio-system` namespace.  This gateway's purpose is to serve
as the main entry point for the entire cluster.

Each app, has a `virtualservice` definition in their own namespace that uses the `main-gateway`.

Example app in namespace `example-app`:
```
curl -v https://example-app.dev01.us-west-2.dev.ds-dev.intacct.com
```

Example app in namespace `example-app-2`:
```
curl -v https://example-app-2.dev01.us-west-2.dev.ds-dev.intacct.com
```

## Inter cluster and cross namespace app reachability
To reach another app in the same cluster but from another namespace you will need to append `<namespace>.svc` to the
hostname.  This DNS will resolve correctly.

```
curl -v http://app1.example-app.svc:8080
```

```
curl -v http://app2.example-app-2.svc:8080
```
