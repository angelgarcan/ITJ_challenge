package com.garcan;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.garcan.models.Request;
import com.garcan.models.Response;
import com.garcan.services.HashGenerator;

public class MainFunction implements RequestHandler<Request, Response> {

    public Response handleRequest(Request request, Context context) {
        Response response = new Response();
        try {
            response.setHash(HashGenerator.generateSHA256Hash(request.getInput()));
        } catch (Exception ex) {
            response.setError(ex.getLocalizedMessage());
        }
        return response;
    }
}
