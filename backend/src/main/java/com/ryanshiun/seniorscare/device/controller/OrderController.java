package com.ryanshiun.seniorscare.device.controller;

import com.ryanshiun.seniorscare.device.dto.OrderRequest;
import com.ryanshiun.seniorscare.device.model.Order;
import com.ryanshiun.seniorscare.device.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 訂單 API
 * - GET /api/orders?memberId=1   查某會員全部訂單
 * - GET /api/orders               查全部（可帶 ?status=PAID）
 * - GET /api/orders/{id}          查單筆
 * - POST /api/orders              建立訂單（由購物車轉訂單）
 */
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@CrossOrigin
public class OrderController {

    private final OrderService svc;

    /** 建立訂單（由購物車轉訂單） */
    @PostMapping
    public ResponseEntity<String> create(@RequestBody OrderRequest req) {
        String message = svc.createOrder(req);
        // 這裡直接回 200/400，亦可視需求回 201 或回傳 OrderResponse
        if ("購買成功".equals(message)) {
            return ResponseEntity.ok(message);
        }
        return ResponseEntity.badRequest().body(message);
    }

    /** 有 memberId 才會匹配：GET /api/orders?memberId=1 */
    @GetMapping(params = "memberId")
    public ResponseEntity<List<Order>> listByMember(@RequestParam Integer memberId) {
        return ResponseEntity.ok(svc.getOrdersByMember(memberId));
    }

    /** 沒有 memberId 才會匹配：GET /api/orders 或 /api/orders?status=PAID */
    @GetMapping(params = "!memberId")
    public ResponseEntity<List<Order>> listAll(
            @RequestParam(value = "status", required = false) String status) {
        String normalized = (status == null || status.isBlank()) ? null : status.trim();
        return ResponseEntity.ok(svc.listAll(normalized));
    }

    /** 查單筆：GET /api/orders/{id} */
    @GetMapping("/{id}")
    public ResponseEntity<Order> getOne(@PathVariable Integer id) {
        Order o = svc.getOrderById(id);
        return o == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(o);
    }
}
