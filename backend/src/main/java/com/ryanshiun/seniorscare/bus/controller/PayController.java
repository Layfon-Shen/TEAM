//package com.ryanshiun.seniorscare.bus.controller;
//
//
//
//import java.nio.charset.StandardCharsets;
//import java.util.Base64;
//import java.util.List;
//import java.util.UUID;
//
//import javax.crypto.Mac;
//import javax.crypto.spec.SecretKeySpec;
//
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.fasterxml.jackson.core.JsonProcessingException;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.ryanshiun.seniorscare.bus.dto.LineRequestParam;
//import com.ryanshiun.seniorscare.bus.dto.LineRequestParam.Prdocut;
//import com.ryanshiun.seniorscare.bus.dto.LineRequestParam.Package;
//import com.ryanshiun.seniorscare.bus.dto.LineRequestParam.RedirectUrls;
//
//
//
//@RequestMapping("/api/pay")
//@RestController
//public class PayController {
//	
//	
//	private final AuthController authController;
//
//	private final String CHANNEL_SECRET = "3ce36b0964108f7029224fe4f8f80fa3";
//	private final String API_PATH = "/v3/payments/request";
//
//
//
//	@GetMapping(path = "/t", produces = "text/html")
//	public String test() throws Exception {
//
//		// 每次請求的唯一識別
//		UUID randomUUID = UUID.randomUUID();
//
//		// 建立請求 body
//		LineRequestParam param = new LineRequestParam();
//		param.setAmount(5000);
//		param.setOrderId(1001);
//
//		RedirectUrls redirectUrls = new LineRequestParam.RedirectUrls();
//		redirectUrls.setConfirmUrl("localhost:8080/ok"); // 結帳成功後導向
//		redirectUrls.setCancelUrl("localhost:8080/cancel"); // 點擊取消後導向
//		param.setRedirectUrls(redirectUrls);
//
//		Prdocut p1 = new LineRequestParam.Prdocut();
//		p1.setId("p1");
//		p1.setImageUrl("");
//		p1.setName("商品A");
//		p1.setPrice(500);
//		p1.setQuantity(5);
//
//		Prdocut p2 = new LineRequestParam.Prdocut();
//		p2.setId("p2");
//		p2.setImageUrl("");
//		p2.setName("商品B");
//		p2.setPrice(500);
//		p2.setQuantity(5);
//
//		List<Prdocut> products = List.of(p1, p2);
//
//		Package package1 = new LineRequestParam.Package();
//		package1.setId("package1");
//		package1.setAmount(5000);
//		package1.setName("商品組A");
//		package1.setProducts(products);
//
//		List<Package> packages = List.of(package1);
//		param.setPackages(packages);
//
//		//把請求的物件轉型成JSON 格式的字串
//		ObjectMapper mapper = new ObjectMapper();
//		String body = mapper.writeValueAsString(param);
//
//		// 算出 mac 值，即是 request header 中的 「X-LINE-Authorization」
//		String message = CHANNEL_SECRET + API_PATH + body + randomUUID;
//		Mac mac = Mac.getInstance("HmacSHA256");
//		SecretKeySpec keySpec = new SecretKeySpec(CHANNEL_SECRET.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
//		mac.init(keySpec);
//		byte[] rawHmac = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
//
//		return """
//				<h1> X-LINE-Authorization: %s </h1>
//				<h1> X-LINE-Authorization-Nonce: %s </h1>
//				<h1> body: %s </h1>
//				""".formatted(Base64.getEncoder().encodeToString(rawHmac), randomUUID, body);
//	}
//}
