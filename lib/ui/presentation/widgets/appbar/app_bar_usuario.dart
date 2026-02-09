import 'package:controle_de_gastos_app/ui/core/utils/utils.dart';
import 'package:controle_de_gastos_app/ui/data/model/user.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/gradients/app_gradients.dart';
import '../../../core/theme/styles/app_text_styles.dart';


class AppBarUser extends PreferredSize {
  AppBarUser(User? user, String texto, BuildContext context, {Key? key}):super(key: key,

    preferredSize: const Size.fromHeight(200),

    child: Container(

      height: 130,
      decoration:  BoxDecoration(
        gradient: AppGradients.redColor,
        color: Colors.orange,
        boxShadow:  const [
          BoxShadow(blurRadius: 50.0)
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )
      ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///Foto:
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child:  Image.asset(
              'assets/images/usuario.png',
              height: MediaQuery.of(context).size.width / 10,
              //   width: MediaQuery.of(context).size.width / 10,
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          ///NOme
          SizedBox(
            height: (MediaQuery.of(context).size.width / 10) - 17,
            // width: MediaQuery.of(context).size.width / 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text('''Olá ${Utils.capitalizeFirstLetter(user?.username ?? '')} $texto''',
                    style: AppTextStyles.titleAppBarUsuario(23, context),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.help, color: Colors.white,),
            // call toggle from SlideDrawer to alternate between open and close
            // when pressed menu button
            onPressed: () {
              ///SlideDrawer.of(context)?.toggle()
              print('menuBar');
            },
          ),
        ],
      ),
    ),
  );
}
