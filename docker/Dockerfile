FROM hashicorp/terraform:1.0.0

# Install system dependencies
RUN apk update && apk --no-cache add \
    gnupg aws-cli \
    bash zsh

WORKDIR /root/workdir

# Cache Terraform plugins
RUN mkdir -p /root/.terraform.d/plugin-cache
ENV TF_PLUGIN_CACHE_DIR /root/.terraform.d/plugin-cache
COPY versions.tf.json versions.tf.json
RUN terraform init

# Cache Terraform modules
COPY main.tf main.tf
COPY modules modules
RUN terraform get

COPY docker/_zshrc /root/.zshrc

ENTRYPOINT ["zsh"]
