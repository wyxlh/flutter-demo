package com.yzsh.power.client.utils;

import android.util.Base64;

import java.security.InvalidKeyException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public class RSAUtil {

  /*
          加密或解密数据的通用方法
          @param srcData
          待处理的数据
          @param key
          公钥或者私钥
          @param mode
          指定是加密还是解密，值为Cipher.ENCRYPT_MODE或者Cipher.DECRYPT_MODE

       */
  public static byte[] processData(byte[] srcData, Key key) {

    //用来保存处理结果
    byte[] resultBytes = null;

    try {

      //构建Cipher对象，需要传入一个字符串，格式必须为"algorithm/mode/padding"或者"algorithm/",意为"算法/加密模式/填充方式"
      Cipher cipher = Cipher.getInstance("RSA/NONE/PKCS1Padding");
      //初始化Cipher，mode指定是加密还是解密，key为公钥或私钥
      cipher.init(Cipher.ENCRYPT_MODE, key);
      //处理数据
      resultBytes = cipher.doFinal(srcData);

    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (NoSuchPaddingException e) {
      e.printStackTrace();
    } catch (InvalidKeyException e) {
      e.printStackTrace();
    } catch (BadPaddingException e) {
      e.printStackTrace();
    } catch (IllegalBlockSizeException e) {
      e.printStackTrace();
    }

    return resultBytes;
  }

  /*
         使用公钥加密数据，结果用Base64转码
      */
  public static String encryptDataByPublicKey(byte[] srcData, PublicKey publicKey) {

    byte[] resultBytes = processData(srcData, publicKey);

    return Base64.encodeToString(resultBytes, Base64.NO_WRAP);

  }

 /*
        将字符串形式的公钥转换为公钥对象
     */

  public static PublicKey keyStrToPublicKey(String publicKeyStr) {

    PublicKey publicKey = null;

    byte[] keyBytes = Base64.decode(publicKeyStr, Base64.DEFAULT);

    X509EncodedKeySpec keySpec = new X509EncodedKeySpec(keyBytes);

    try {

      KeyFactory keyFactory = KeyFactory.getInstance("RSA");

      publicKey = keyFactory.generatePublic(keySpec);

    } catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    } catch (InvalidKeySpecException e) {
      e.printStackTrace();
    }

    return publicKey;

  }
}
