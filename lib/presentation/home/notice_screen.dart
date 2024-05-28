import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yanapa/adhelp.dart';
import 'package:yanapa/core/utils/admob_controller.dart';
import 'package:yanapa/presentation/remoteconfigs/jsonNoticeRemote.dart';
import 'package:yanapa/presentation/remoteconfigs/remoteconfigs_controller.dart';

class NoticeScreen extends StatelessWidget {
  NoticeScreen({super.key});
  RemoteConfigController remoteConfigController = Get.find();
  AdMobController adMobController = Get.find();
  int iCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Center(child: SvgPicture.asset('assets/images/logobanner.svg')),
            adMobController.isBottomBannerAdLoaded.value
                // ? MyAdWidget()
                ? SizedBox(
                    height:
                        adMobController.bottomBannerAd.size.height.toDouble(),
                    width: adMobController.bottomBannerAd.size.width.toDouble(),
                    child: MyAdWidget(),
                  )
                : Container(),
            ...(remoteConfigController.jsonNoticeRemoteSection?.listOfNotices ??
                    [])
                .map(
              (notice) {
                iCount = iCount + 1;
                if (iCount % 3 == 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _noticeItem(notice),
                      adMobController.isBottomBannerAdLoaded.value
                          // ? MyAdWidget()
                          ? SizedBox(
                              height: adMobController.bottomBannerAd.size.height
                                  .toDouble(),
                              width: adMobController.bottomBannerAd.size.width
                                  .toDouble(),
                              child: MyAdWidget(),
                            )
                          : Container(),
                    ],
                  );
                }
                return _noticeItem(notice);
              },
            ).toList(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Padding _noticeItem(ListOfNotice notice) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          launchUrlString(notice.urlToRedirect ?? 'https://www.google.com');
        },
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(notice.urlPhotoOrigin ?? ''),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice.nameOrigin ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          timeAgo(notice.publicationDate ?? DateTime.now()),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                notice.publicationTitle ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                notice.publicationDescription ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Tiempo de lectura: ${notice.publicationRedTimeInMinutes ?? ''} min",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  notice.publicationImage ?? '',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime dateTime) {
    Duration diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) {
      return 'Publicado hace ${diff.inSeconds} segundos';
    } else if (diff.inMinutes < 60) {
      return 'Publicado hace ${diff.inMinutes} minutos';
    } else if (diff.inHours < 24) {
      return 'Publicado hace ${diff.inHours} horas';
    } else if (diff.inDays < 30) {
      return 'Publicado hace ${diff.inDays} días';
    } else if (diff.inDays < 365) {
      return 'Publicado hace ${diff.inDays ~/ 30} meses';
    } else {
      return 'Publicado hace ${diff.inDays ~/ 365} años';
    }
  }
}
