FROM tomcat:10.1-jdk17-temurin

# Xóa web mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR app vào Tomcat
COPY ConnectionPooling-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war

# Config Tomcat để dùng PORT Render cung cấp
CMD sed -ri 's/port="8080"/port="${PORT:-8080}"/' /usr/local/tomcat/conf/server.xml && \
    catalina.sh run
