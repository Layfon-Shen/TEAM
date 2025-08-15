
package com.ryanshiun.seniorscare.device.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 後台更新訂單付款狀態請求 DTO
 *
 * 此物件用於後台 API，攜帶新的付款狀態及可選的支付平臺交易編號，
 * 便於系統記錄、對帳與客服查詢。
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentUpdateRequest {

    /**
     * 付款狀態
     * 可選值：
     * <ul>
     *   <li>"PAID"：已付款</li>
     *   <li>"FAILED"：付款失敗</li>
     *   <li>"REFUNDED"：已退款</li>
     * </ul>
     */
    private String paymentStatus;

    /**
     * （可選）支付平臺交易編號
     *
     * 用於支付對帳、問題排查及客服查詢。
     */
    private String transactionNo;
}
