package br.com.streampix.app.models.checkout;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;;

@NoArgsConstructor
@AllArgsConstructor
@Data
public class Checkout implements Serializable {

    private String nickname;
    private String message;
    private String value;
    private String expTime;

}