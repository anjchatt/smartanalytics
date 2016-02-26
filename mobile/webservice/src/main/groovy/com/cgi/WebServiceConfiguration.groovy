package com.cgi

import com.fasterxml.jackson.annotation.JsonProperty
import io.dropwizard.Configuration
import org.hibernate.validator.constraints.NotEmpty

import javax.validation.constraints.NotNull

class WebServiceConfiguration extends Configuration {
    @JsonProperty
    @NotEmpty
    String locations_csv

    @JsonProperty
    @NotNull
    Double lookup_radius

    @JsonProperty
    String notification_number = null

    @JsonProperty
    @NotEmpty
    String plivo_id

    @JsonProperty
    @NotEmpty
    String plivo_token

    @JsonProperty
    @NotEmpty
    String plivo_number
    
    @JsonProperty
    String proxy_ip

    @JsonProperty
    int proxy_port
    
}
