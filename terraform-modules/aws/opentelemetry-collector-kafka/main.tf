resource "kubernetes_manifest" "open_telemetry_collector" {
  for_each = var.collector_configs
  manifest = {
    "apiVersion" = "opentelemetry.io/v1alpha1"
    "kind"       = "OpenTelemetryCollector"
    "metadata" = {
      "name"      = each.value.name
      "namespace" = each.value.namespace
      "labels"    = {
        "app.kubernetes.io/managed-by": "opentelemetry-operator"
      }
    }
    "spec" = {
      "env" = [
        {
          "name" = "KAFKA_USERNAME"
          "valueFrom" = {
            "secretKeyRef" = {
              "name" = each.value.name
              "key"  = "kafka-username"
            }
          }
        },
        {
          "name" = "KAFKA_PASSWORD"
          "valueFrom" = {
            "secretKeyRef" = {
              "name" = each.value.name
              "key"  = "kafka-password"
            }
          }
        }
      ]
      "config" = <<CONFIG
        receivers:
             otlp:
               protocols:
                 grpc:
                 http:
             zipkin:
             jaeger:
               protocols:
                 thrift_compact:
        processors:
          memory_limiter:
            check_interval: 1s
            limit_percentage: 75
            spike_limit_percentage: 15
          batch:
            send_batch_size: 10000
            timeout: 10s
    
        exporters:
          debug:
            # see https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/kafkaexporter
          kafka/metrics:
            protocol_version: 2.0.0
            brokers:
              - "${each.value.bootstrap}:${each.value.port}"
            encoding: otlp_json
            client_id: each.value.name
            topic: sif.otel.metrics
            auth:
              sasl:
                username: "$${env:KAFKA_USERNAME}"
                password: "$${env:KAFKA_PASSWORD}"
                mechanism: SCRAM-SHA-512
    
        service:
          pipelines:
            traces:
              receivers: [otlp, zipkin, jaeger]
              processors: [memory_limiter, batch]
              exporters: [debug]
            metrics:
              receivers: [otlp]
              processors: [memory_limiter, batch]
              exporters: [kafka/metrics]
        mode: deployment
        resources: { }
        targetAllocator: { }
        upgradeStrategy: automatic
      CONFIG
    }
  }
}

resource "kubernetes_manifest" "instrumentation" {
  for_each = var.collector_configs
  manifest = {
    "apiVersion" = "opentelemetry.io/v1alpha1"
    "kind"       = "Instrumentation"
    "metadata" = {
      "name" = "${each.value.name}-instr"
      "namespace" = each.value.namespace
    }
    "spec" = {
      "exporter" = {
        "endpoint" = "http://${each.value.name}.monitoring.svc.cluster.local:4317"
      }
      "propagators" = [
        "tracecontext",
        "baggage",
        "b3"
      ]
      "sampler" = {
        "type" = "always_on"
      }
    }
  }
}

resource "kubernetes_manifest" "external_secret" {
  for_each = var.collector_configs
  manifest = {
    "apiVersion" = "external-secrets.io/v1alpha1"
    "kind"       = "ExternalSecret"
    "metadata" = {
      "name" = each.value.name
      "namespace" = each.value.namespace
    }
    "spec" = {
      "refreshInterval" = "1h0m0s"
      "secretStoreRef" = {
        "name" = "secretstore-main"
        "kind" = "ClusterSecretStore"
      }
      "target" = {
        "name" = each.value.name
      }
      "data" = [
        {
          "secretKey" = "kafka-username"
          "remoteRef" = {
            "key" = each.value.secret_name
            "property" = "kafka-username"
          }
        },
        {
          "secretKey" = "kafka-password"
          "remoteRef" = {
            "key" = each.value.secret_name
            "property" = "kafka-password"
          }
        }
      ]
    }
  }
}