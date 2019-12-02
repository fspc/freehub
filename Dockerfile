###########
# FreeHub #
###########
# Password is test for greeter, sfbk, mechanic, scbc, cbi, admin

FROM ruby:1.9.3
MAINTAINER Jonathan Rosenbaum <gnuser@gmail.com>

RUN apt-get update && apt-get install -y lsb-release git supervisor make

# Install mysql 5.6
# From https://www.debiantutorials.com/how-to-install-mysql-server-5-6-or-5-7/
ENV DEBIAN_FRONTEND noninteractive
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.9-1_all.deb
RUN echo mysql-apt-config mysql-apt-config/select-server select mysql-5.6 | debconf-set-selections
RUN echo mysql-community-server mysql-community-server/root-pass password '' | debconf-set-selections
RUN dpkg -i mysql-apt-config_0.8.9-1_all.deb
RUN dpkg-preconfigure mysql-community-server_version-and-platform-specific-part.deb
RUN apt-get update && apt-get install -y --force-yes mysql-community-server

# Install freehub
RUN git clone git://github.com/asalant/freehub.git
RUN gem install bundler -v 1.15.4
RUN bundle install --gemfile=/freehub/Gemfile

# Bootstrap freehub
RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && service mysql start; \
    cd /freehub; rake db:create:all; rake db:migrate; rake db:fixtures:load

COPY  mysql.conf /etc/supervisor/conf.d/
COPY  freehub.conf /etc/supervisor/conf.d/

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# docker run -d -p 3000:3000 --name="freehub" bikebike/freehub
