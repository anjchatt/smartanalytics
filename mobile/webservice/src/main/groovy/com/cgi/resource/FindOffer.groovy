package com.cgi.resource

import ch.qos.logback.classic.Logger
import com.cgi.model.Location
import com.plivo.helper.api.client.RestAPI
import org.slf4j.LoggerFactory

import javax.annotation.Nullable
import javax.validation.Valid
import javax.validation.constraints.NotNull
import javax.ws.rs.GET
import javax.ws.rs.Path
import javax.ws.rs.Produces
import javax.ws.rs.QueryParam
import javax.ws.rs.core.MediaType

import org.apache.http.HttpHost

import static com.cgi.GeoUtils.distance

@Path("/find-offer")
@Produces(MediaType.APPLICATION_JSON)
class FindOffer {
    final static  Logger LOG = LoggerFactory.getLogger(FindOffer.class)

    List<Location> locations
    Double lookupRadius
    String notificationNumber
    String plivo_id, plivo_token, plivo_number
    String proxy_ip
    int proxy_port

    public FindOffer(@NotNull List<Location> locations, @NotNull Double lookupRadius,
                     @Nullable String notificationNumber,
                     @NotNull String plivo_id, @NotNull String plivo_token, String plivo_number,
                     @Nullable String proxy_ip, @Nullable int proxy_port) {
        this.locations = locations
        this.lookupRadius = lookupRadius
        this.notificationNumber = notificationNumber
        this.plivo_id = plivo_id
        this.plivo_token = plivo_token
        this.plivo_number = plivo_number
        this.proxy_ip = proxy_ip
        this.proxy_port = proxy_port
    }

    @GET
    public Location find(
            @QueryParam("userId") String userId,
            @Valid @NotNull @QueryParam("lat") Double lat, @NotNull @Valid @QueryParam("lon") Double lon) {
        def locationsDistance = locations.<Location, Double, Location> collectEntries {
            [(it): distance(it.lat, it.lon, lat, lon)]
        }
        if (notificationNumber) {
            def inRadius = locationsDistance.findAll { it.value <= lookupRadius }
            def closest = inRadius.min({ it.value })?.key
            LOG.info("Trying to send location info $closest to $notificationNumber")
            if (closest) {
                def text = "Get your free coffee at Starbucks near your: " + closest.address
                RestAPI api = new RestAPI(plivo_id, plivo_token, "v1");
                if(proxy_ip){
                    HttpHost proxy = new HttpHost(proxy_ip, proxy_port);
                    api.setProxy(proxy)
                }
                def params = ["src" : plivo_number,
                              "dst" : notificationNumber,
                              "text": text,
                              "url" : "http://server/message/notification/"]
                def msgResponse = api.sendMessage(params);
            }
        }
        return locationsDistance.min({ it.value }).key
    }
}
