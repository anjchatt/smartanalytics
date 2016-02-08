package com.cgi

import com.cgi.model.Location
import com.cgi.resource.FindOffer

import com.opencsv.CSVReader
import io.dropwizard.Application
import io.dropwizard.setup.Bootstrap
import io.dropwizard.setup.Environment

class WebService extends Application<WebServiceConfiguration> {
    public static void main(String[] args) throws Exception {
        new WebService().run(args);
    }

    @Override
    public String getName() {
        return "Mobile WebService";
    }

    @Override
    public void initialize(Bootstrap<WebServiceConfiguration> bootstrap) {
    }

    @Override
    void run(WebServiceConfiguration configuration, Environment environment) throws Exception {
        def reader = new CSVReader(new FileReader(configuration.locations_csv), (char) ",", (char) '"');
        def locationsCsv = reader.readAll();
        def locations = locationsCsv.collect {
            new Location(
                    lat: it[0].toDouble(),
                    lon: it[1].toDouble(),
                    desc: it[2],
                    address: it[3].replace("<br>", ', ')
            )
        }
        final def findOfferResource = new FindOffer(locations, configuration.lookup_radius, configuration.notification_number,
                configuration.plivo_id, configuration.plivo_token, configuration.plivo_number)
        environment.jersey().register(findOfferResource);
    }
}
