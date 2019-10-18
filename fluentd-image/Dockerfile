FROM fluent/fluentd:v1.6.2-1.0

# Use root account to use apk
USER root

# below RUN includes plugin as examples elasticsearch is not required
# you may customize including plugins as you wish
RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && gem install \
        fluent-plugin-elasticsearch \
        fluent-plugin-concat \
        fluent-plugin-grok-parser \
        fluent-plugin-elasticsearch-timestamp-check \
        fluent-plugin-prometheus \
        fluent-plugin-record-modifier \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && apk add --no-cache tzdata \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem /var/cache/apk/*

USER fluent