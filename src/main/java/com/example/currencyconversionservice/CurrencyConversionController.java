package com.example.currencyconversionservice;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
public class CurrencyConversionController {
	
	@Autowired
	private Environment environment;
	
	@GetMapping("/currency-converter/from/{from}/to/{to}/quantity/{quantity}") // where {from} and {to} represents the
																				// column
	// returns a bean back
	public CurrencyConversionBean convertCurrency(@PathVariable String from, @PathVariable String to,
			@PathVariable BigDecimal quantity) {
		
		// setting variables to currency exchange service
		Map<String, String> uriVariables = new HashMap<>();
		uriVariables.put("from", from);
		uriVariables.put("to", to);
		
		// get exchange service url
		String currencyExchangeUrl = environment.getProperty("currency.exchange.url") + "/currency-exchange/from/{from}/to/{to}";
		
		// calling the currency-exchange-service
		ResponseEntity<CurrencyConversionBean> responseEntity = new RestTemplate().getForEntity(
				currencyExchangeUrl, 
				CurrencyConversionBean.class,
				uriVariables);

		CurrencyConversionBean response = responseEntity.getBody();
		// creating a new response bean and getting the response back and taking it into
		// Bean
		return new CurrencyConversionBean(
				response.getId(), 
				from, 
				to, 
				response.getConversionMultiple(), 
				quantity,
				quantity.multiply(response.getConversionMultiple()), 
				response.getPort());
	}
}