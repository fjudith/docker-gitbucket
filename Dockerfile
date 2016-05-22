FROM tomcat:8-jre8

MAINTAINER Florian JUDITH <florian.judith.b@gmail.com>

LABEL version=4.00
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm
ENV GITBUCKET_HOME=/var/gitbucket

ENV BASE_URL=${BASE_URL:-http\://git.mycompany.com/gitbucket}
ENV ALLOW_ACCOUNT_REGISTRATION=${ALLOW_ACCOUNT_REGISTRATION:-false}
ENV ALLOW_ANONYMOUS_ACCESS=${ALLOW_ANONYMOUS_ACCESS:-true}
ENV IS_CREATE_REPOSITORY_OPTION_PUBLIC=${IS_CREATE_REPOSITORY_OPTION_PUBLIC:-true}
ENV GRAVATAR=${GRAVATAR:-true}

ENV NOTIFICATION=${NOTIFICATION:-true}
ENV SMTP_HOST=${SMTP_HOST:-smtp.mycompany.com}
ENV SMTP_PORT=${SMTP_PORT:-25}
ENV SMTP_FROM_ADDRESS=${SMTP_FROM_ADDRESS:-dummy@mycompany.com}
ENV SMTP_FROM_NAME=${SMTP_FROM_NAME:-"GitBucket Admin"}

ENV LDAP_AUTHENTICATION=${LDAP_AUTHENTICATION:-false}
ENV LDAP_HOST=${LDAP_HOST:-ldap.mycompany.com}
ENV LDAP_PORT=${LDAP_PORT:-389}
ENV LDAP_BASEDN=${LDAP_BASEDN:-OU\=User,DC\=COMPANY,DC\=COM}
ENV LDAP_USERNAME_ATTRIBUTE=${LDAP_USERNAME_ATTRIBUTE:-sAMAccountName}
ENV LDAP_FULLNAME_ATTRIBUTE=${LDAP_FULLNAME_ATTRIBUTE:-cn}
ENV LDAP_MAIL_ATTRIBUTE=${LDAP_MAIL_ATTRIBUTE:-mail}

ENV SSH=${SSH:-true}
ENV SSH_PORT=${SSH_PORT:-29418}

RUN rm -rf /usr/local/tomcat/webapps/ROOT

ADD https://github.com/gitbucket/gitbucket/releases/download/4.0/gitbucket.war /usr/local/tomcat/webapps/ROOT.war

RUN cd /usr/local/tomcat/webapps; \
    ln -s ROOT.war gitbucket-4.00

RUN mkdir -p $GITBUCKET_HOME/plugins; \
    cd $GITBUCKET_HOME/plugins; \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/takezoe/gitbucket-gist-plugin/releases \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/gitbucket-plugins/gitbucket-announce-plugin/releases \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/gitbucket-plugins/gitbucket-h2-backup-plugin/releases \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/yoshiyoshifujii/gitbucket-desktopnotify-plugin/releases \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/yoshiyoshifujii/gitbucket-commitgraphs-plugin/releases \
    wget -nv -r -A .jar -e robots=off -nd https://github.com/asciidoctor/gitbucket-asciidoctor-plugin/releases





VOLUME $GITBUCKET_HOME
WORKDIR $GITBUCKET_HOME
EXPOSE 8080
EXPOSE 29418
CMD [ "/usr/local/tomcat/bin/catalina.sh", "run" ]