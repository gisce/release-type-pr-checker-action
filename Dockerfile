FROM python:3.11-alpine

LABEL repository="https://github.com/gisce/release-type-pr-checker-action"
LABEL homepage="https://github.com/gisce/release-type-pr-checker-action"
LABEL maintainer="Pol Sala <polsalalidon@gmail.com>"

LABEL com.github.actions.name="Release type PR check"
LABEL com.github.actions.description="A GitHub Action to check pullrequest labels [patch minor major]."
LABEL com.github.actions.icon="github"
LABEL com.github.actions.color="pink"

RUN apk add --no-cache --upgrade expat libuuid jq

COPY python/requirements.txt /action/
RUN apk add --no-cache build-base libffi-dev; \
    pip install --upgrade --force --no-cache-dir pip && \
    pip install --upgrade --force --no-cache-dir -r /action/requirements.txt; \
    apk del build-base libffi-dev

#COPY python/release_type_pr_checker.py /action/
COPY bash/scripts/release_type_pr_checker.sh /action/

ENTRYPOINT ["/action/release_type_pr_checker.sh"]