package com.cgi.model

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@ToString
@EqualsAndHashCode
class Location {
    double lat, lon
    String desc
    String address
}
