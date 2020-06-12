
import 'package:client/ui/common/themeTextStyles.dart';
import 'package:client/ui/shared/help.dart';
import 'package:flutter/material.dart';
import 'package:client/core/extension/int_extension.dart';

class YZCEditBox extends StatelessWidget {
  final String title;
  final String hint;
  final bool autofocus;
  final bool obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final Widget suffixIcon;

  YZCEditBox({
    Key key,
    this.title,
    this.hint,
    this.autofocus,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.controller,
    this.suffixIcon,
  }): super(key: key);

  @override
  Widget build(BuildContext context){
    InputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        color: WFHelp.mainHintTextColor,
        width: 1,
      ),
    );
    return TextFormField(
      keyboardType: inputType,
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        //labelText: '手机号',
        //labelStyle: TextStyle(color: Colors.black),
        hintText: hint,
        hintStyle: ThemeTextStyle.styleFormHint,
        prefixIcon: Container(
            width: 60.px,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(title, style: ThemeTextStyle.styleFormTitle),// Icon(Icons.person),
              ],
            )
        ),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: border,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
