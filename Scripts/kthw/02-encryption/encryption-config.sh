ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)

cat > encryption-config.yaml << EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF


# scp to masters
scp encryption-config.yaml cloud_user@35.178.49.15:~/
scp encryption-config.yaml cloud_user@35.178.191.98:~/