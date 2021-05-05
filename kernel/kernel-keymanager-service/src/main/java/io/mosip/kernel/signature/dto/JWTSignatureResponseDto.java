package io.mosip.kernel.signature.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 
 * @author Mahammed Taheer
 * @since 1.1.5.1
 *
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class JWTSignatureResponseDto {

	/**
	 * encrypted data
	 */
	private String jwtSignedData;

	/**
	 * response time.
	 */
	private LocalDateTime timestamp;
}
