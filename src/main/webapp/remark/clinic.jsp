<?xml version='1.0'?>
<jsp:root version='2.0'
          xmlns:jsp="http://java.sun.com/JSP/Page"
          xmlns:util="urn:jsptagdir:/WEB-INF/tags"
          xmlns:c="http://java.sun.com/jsp/jstl/core">
    <jsp:directive.page contentType="text/html"/>
    <html>
    <head>
    </head>
    <body>
    <c:set var="cityName" value="Montreal"/>
    <util:lookup cityName="${cityName}">
        ${cityName}'s province is ${province}.
        ${cityName}'s population is approximately ${population / 1000000} million.
    </util:lookup>
    </body>
    </html>
</jsp:root>