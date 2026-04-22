require "import"
import "android.app.AlertDialog"
import "android.content.DialogInterface"
import "android.widget.LinearLayout"
import "android.widget.TextView"
import "android.widget.Button"
import "android.widget.ScrollView"
import "android.widget.Toast"
import "java.io.File"
import "java.io.FileOutputStream"
import "org.json.JSONObject"
import "android.os.Handler"
import "android.os.Looper"
import "java.lang.String"
import "java.lang.Runnable"
import "java.lang.Thread"
import "android.view.WindowManager"
import "android.os.Build"
import "java.util.Calendar"
import "java.text.SimpleDateFormat"
import "java.util.Date"
import "java.util.Locale"
import "android.content.Intent"
import "android.net.Uri"
import "com.androlua.Http"

local CONFIG_PATH = "/storage/emulated/0/解说/AdvanceWomenHelperConfig.txt"
local HELPLINE_URL = "https://raw.githubusercontent.com/example/helpline.json"

local defaultIndiaData = [[{"numbers":[{"name":"Women Helpline","number":"181","description":"यह हेल्पलाइन उन महिलाओं की मदद के लिए है जो किसी भी तरह की परेशानी, घरेलू हिंसा या मानसिक तनाव का सामना कर रही हैं, यहाँ कॉल करके आप न सिर्फ अपनी शिकायत दर्ज करा सकती हैं, बल्कि आपको सही सलाह, सरकारी योजना की जानकारी, और मुफ्त कानूनी मदद भी दी जाती है"},{"name":"Emergency Helpline","number":"112","description":"यह भारत सरकार का एक मुख्य और सबसे ज़रूरी आपातकालीन नंबर है, अगर आप किसी भी बड़ी मुसीबत में हैं, तो इस एक नंबर पर कॉल करके आप पुलिस, एम्बुलेंस और फायर ब्रिगेड तीनों की तुरंत मदद प्राप्त कर सकती हैं, यह नंबर हर राज्य में काम करता है"},{"name":"Child Helpline","number":"1098","description":"यह नंबर खास तौर पर छोटे बच्चों और बच्चियों की सुरक्षा और मदद के लिए बनाया गया है, अगर आप किसी बच्चे को मुसीबत में देखते हैं, या किसी बच्चे से मज़दूरी कराई जा रही है, तो आप तुरंत इस नंबर पर सूचना दे सकते हैं, कॉल करने वाले की पहचान पूरी तरह से गुप्त रखी जाती है"},{"name":"Cyber Crime Helpline","number":"1930","description":"यह भारत सरकार का साइबर अपराध निवारण नंबर है, अगर आपके साथ इंटरनेट पर कोई धोखा हुआ है, बैंक खाते से गलत तरीके से पैसे कट गए हैं, या सोशल मीडिया पर कोई आपको ब्लैकमेल कर रहा है, तो बिना डरे तुरंत इस नंबर पर अपनी शिकायत दर्ज कराएं ताकि आपके पैसे और सम्मान को बचाया जा सके"},{"name":"NCW Helpline","number":"7827170170","description":"यह राष्ट्रीय महिला आयोग का मुख्य हेल्पलाइन नंबर है, यह संस्था महिलाओं के अधिकारों की रक्षा के लिए काम करती है, अगर आपकी शिकायत कहीं और नहीं सुनी जा रही है, या आपके साथ कार्यस्थल पर कोई दुर्व्यवहार हुआ है, तो आप यहाँ सीधे अपनी शिकायत दर्ज करा सकती हैं"},{"name":"NCW Emergency Number","number":"14490","description":"यह राष्ट्रीय महिला आयोग द्वारा शुरू किया गया एक नया और सीधा इमरजेंसी नंबर है, इसका मकसद संकट में फंसी महिलाओं को जल्द से जल्द सहायता पहुँचाना है, किसी भी गंभीर स्थिति में आप इस नंबर पर कॉल करके सीधे आयोग के अधिकारियों से बात कर सकती हैं"},{"name":"Mental Health Helpline","number":"14416","description":"यह भारत सरकार की टेलि मानस हेल्पलाइन है, अगर आप बहुत ज़्यादा तनाव, घबराहट या निराशा महसूस कर रही हैं, तो इस नंबर पर कॉल करके आप विशेषज्ञ डॉक्टरों से किसी भी समय मुफ्त में बात कर सकती हैं, यह सेवा आपकी पहचान को गुप्त रखती है"}]}]]
local defaultPakistanData = [[{"numbers":[{"name":"National Women Helpline","number":"1099","description":"यह पाकिस्तान के मानव अधिकार मंत्रालय द्वारा चलाई जा रही मुख्य हेल्पलाइन है, अगर किसी महिला या बच्चे के साथ घरेलू हिंसा, अधिकारों का हनन या कोई दुर्व्यवहार हो रहा है, तो तुरंत इस नंबर पर शिकायत दर्ज कराएं ताकि आपको सरकारी मदद और कानूनी सहायता मिल सके"},{"name":"Punjab Women Helpline","number":"1043","description":"यह पंजाब महिला आयोग की 24 घंटे चलने वाली खास और मुफ्त हेल्पलाइन है, अगर आप काम की जगह पर परेशानी, घरेलू हिंसा, या संपत्ति मामलों का सामना कर रही हैं, तो यहाँ से आपको मुफ्त कानूनी सलाह और पूरी मदद मिलेगी"},{"name":"Police Emergency","number":"15","description":"यह पाकिस्तान पुलिस का मुख्य आपातकालीन नंबर है, किसी भी तरह के अचानक खतरे, चोरी, हमले या असुरक्षा की स्थिति में फौरन इस नंबर पर कॉल करके आप पुलिस को मदद के लिए बुला सकती हैं"},{"name":"Rescue 1122","number":"1122","description":"यह पाकिस्तान की सबसे बड़ी और तेज़ इमरजेंसी एम्बुलेंस सर्विस है, किसी भी मेडिकल इमरजेंसी, अचानक दुर्घटना या आग लगने जैसी स्थिति में तुरंत 1122 डायल करके आप मुफ्त मदद मांग सकती हैं"},{"name":"FIA Cyber Crime","number":"1991","description":"यह पाकिस्तान की संघीय जांच एजेंसी यानी एफआईए का साइबर अपराध शिकायत नंबर है, अगर इंटरनेट या सोशल मीडिया पर आपके साथ कोई ब्लैकमेलिंग, धोखाधड़ी या उत्पीड़न हो रहा है, तो बेझिझक यहाँ अपनी रिपोर्ट दर्ज कराएं"},{"name":"Madadgaar Helpline","number":"1098","description":"यह नंबर खास तौर पर बच्चों और महिलाओं की सुरक्षा के लिए काम करता है, किसी भी बच्चे को खतरे में देखने या गुमशुदा बच्चों की रिपोर्ट दर्ज कराने के लिए बिना डरे इस नंबर का इस्तेमाल करें"},{"name":"DRF Cyber Helpline","number":"080039393","description":"यह डिजिटल राइट्स फाउंडेशन की खास हेल्पलाइन है, अगर इंटरनेट या सोशल मीडिया पर किसी महिला को परेशान किया जा रहा है, या कोई ब्लैकमेलिंग हो रही है, तो इस नंबर पर कॉल करके कानूनी और मानसिक मदद ली जा सकती है"},{"name":"Sindh Women Helpline","number":"1094","description":"यह हेल्पलाइन खास तौर पर सिंध प्रांत की महिलाओं के लिए है, किसी भी तरह की घरेलू हिंसा या इमरजेंसी में सिंध की महिलाएं इस नंबर पर तुरंत मदद मांग सकती हैं"},{"name":"Bolo Helpline KPK","number":"080022227","description":"यह हेल्पलाइन खैबर पख्तूनख्वा सरकार की तरफ से है, जो महिलाओं को घरेलू हिंसा और उनके अधिकारों के हनन के खिलाफ मुफ्त कानूनी और मानसिक मदद देती है"}]}]]
local defaultBangladeshData = [[{"numbers":[{"name":"National Helpline for Women","number":"109","description":"यह बांग्लादेश का सबसे मुख्य महिला और बाल सुरक्षा हेल्पलाइन नंबर है, अगर किसी महिला या बच्चे पर अत्याचार हो रहा है, तो इस नंबर पर मुफ्त कॉल करके तुरंत सरकारी मदद ली जा सकती है, यह सेवा 24 घंटे चालू रहती है"},{"name":"National Emergency","number":"999","description":"यह बांग्लादेश का मुख्य आपातकालीन नंबर है, किसी भी खतरे की स्थिति में इस एक नंबर पर कॉल करके आप पुलिस, फायर ब्रिगेड और एम्बुलेंस की फौरन मदद हासिल कर सकती हैं"},{"name":"Child Helpline","number":"1098","description":"यह नंबर खास तौर पर छोटे बच्चों और बच्चियों की सुरक्षा और मदद के लिए बनाया गया है, अगर आप किसी बच्चे को मुसीबत में देखते हैं, किसी बच्चे से मज़दूरी कराई जा रही है या फिर कहीं पर बाल विवाह हो रहा है, तो आप तुरंत इस नंबर पर कॉल करके शिकायत दर्ज करा सकते हैं, कॉल करने वाले की पहचान पूरी तरह से गुप्त रखी जाती है"},{"name":"National Info Service","number":"333","description":"यह बांग्लादेश सरकार का नागरिक सेवा नंबर है, यहाँ से आप किसी भी सरकारी सेवा की जानकारी ले सकती हैं और सामाजिक समस्याओं जैसे बाल विवाह या दहेज के खिलाफ शिकायत भी दर्ज करा सकती हैं"},{"name":"Ain o Salish Kendra","number":"01724415677","description":"यह ऐन ओ सालिश केंद्र का नंबर है जो महिलाओं को घरेलू हिंसा और अधिकारों के हनन के खिलाफ कानूनी मदद और सुरक्षित शरण देने का काम करता है"},{"name":"Cyber Support for Women","number":"01320000888","description":"यह बांग्लादेश पुलिस का खास साइबर सपोर्ट नंबर है, अगर इंटरनेट या फेसबुक पर किसी महिला को ब्लैकमेल या परेशान किया जा रहा है, तो इस नंबर पर शिकायत दर्ज कराकर पुलिस की मदद ली जा सकती है"}]}]]
local defaultNepalData = [[{"numbers":[{"name":"National Women Commission","number":"1145","description":"यह नेपाल के राष्ट्रीय महिला आयोग का मुख्य टोल फ्री नंबर है जिसे खबर गरौँ भी कहा जाता है, अगर किसी महिला के साथ कोई घरेलू हिंसा या अपराध हो रहा है, तो इस नंबर पर मुफ्त कॉल करके शिकायत दर्ज कराई जा सकती है"},{"name":"Women and Children Service","number":"104","description":"यह नेपाल पुलिस का खास महिला और बाल सेवा नंबर है, महिलाओं और बच्चों के खिलाफ होने वाले किसी भी तरह के अपराध या दुर्व्यवहार की स्थिति में पुलिस की फौरन मदद के लिए यह नंबर डायल करें"},{"name":"Anti Trafficking Helpline","number":"1149","description":"यह मानव तस्करी रोकने के लिए नेपाल पुलिस की खास हेल्पलाइन है, अगर किसी महिला या बच्ची को ज़बरदस्ती ले जाने या बेचने का शक हो, तो तुरंत इस नंबर पर सूचना दें"},{"name":"Police Emergency","number":"100","description":"यह नेपाल पुलिस का मुख्य आपातकालीन नंबर है, किसी भी अचानक खतरे या हमले के वक्त पुलिस को तुरंत मदद के लिए बुलाने के लिए आप इस नंबर का इस्तेमाल कर सकती हैं"},{"name":"Emergency Ambulance","number":"102","description":"यह नेपाल की राष्ट्रीय एम्बुलेंस सेवा है, বিপদ या अचानक बीमारी की हालत में तुरंत एम्बुलेंस बुलाने के लिए इस नंबर पर कॉल करें"},{"name":"Child Helpline","number":"1098","description":"यह नेपाल का मुख्य चाइल्ड हेल्पलाइन नंबर है, अगर आप किसी बच्चे को खतरे में देखते हैं, बाल मज़दूरी कराई जा रही है या कोई और परेशानी है, तो इस नंबर पर तुरंत शिकायत दर्ज कराएं"}]}]]
local defaultSriLankaData = [[{"numbers":[{"name":"Women Help Line","number":"1938","description":"यह श्रीलंका के महिला और बाल मंत्रालय द्वारा चलाई जा रही मुख्य हेल्पलाइन है, अगर कोई महिला किसी भी तरह की हिंसा या भेदभाव का सामना कर रही है, तो इस नंबर पर कॉल करके तुरंत सरकारी और कानूनी मदद ली जा सकती है"},{"name":"Child Help Line","number":"1929","description":"यह राष्ट्रीय बाल संरक्षण प्राधिकरण का खास हेल्पलाइन नंबर है, अगर आप किसी बच्चे को खतरे में देखते हैं या बच्चों के खिलाफ हो रहे किसी अपराध की सूचना देना चाहते हैं, तो तुरंत इस नंबर पर कॉल करें"},{"name":"Police Emergency","number":"119","description":"यह श्रीलंका पुलिस का मुख्य आपातकालीन नंबर है, किसी भी तरह के अचानक हमले, खतरे या सुरक्षा की ज़रूरत होने पर आप इस नंबर पर कॉल करके पुलिस को मदद के लिए बुला सकती हैं"},{"name":"Emergency Ambulance","number":"1990","description":"यह श्रीलंका की मुफ्त और तेज़ एम्बुलेंस सेवा है, किसी भी मेडिकल इमरजेंसी या अचानक दुर्घटना होने पर इस नंबर पर कॉल करके तुरंत एम्बुलेंस बुलाई जा सकती है"},{"name":"Mental Health Support","number":"1333","description":"यह नंबर मानसिक सहायता और संकट के समय मदद के लिए है, अगर कोई महिला बहुत ज़्यादा तनाव या घबराहट महसूस कर रही है, तो यहाँ कॉल करके विशेषज्ञ काउंसलर से बात की जा सकती है"},{"name":"Women and Children Bureau","number":"0112444444","description":"यह श्रीलंका पुलिस के महिला और बाल ब्यूरो का सीधा नंबर है, यहाँ कॉल करके आप महिलाओं के खिलाफ होने वाले अपराधों की सीधे रिपोर्ट दर्ज करा सकती हैं"}]}]]
local defaultChinaData = [[{"numbers":[{"name":"Women Federation","number":"12338","description":"यह चीन की ऑल चाइना वीमेंस फेडरेशन का मुख्य हेल्पलाइन नंबर है, अगर कोई महिला घरेलू हिंसा का सामना कर रही है या उसे अपने अधिकारों के लिए मदद चाहिए, तो इस नंबर पर कॉल करके तुरंत सहायता प्राप्त की जा सकती है"},{"name":"Police Emergency","number":"110","description":"यह चीन की पुलिस का मुख्य आपातकालीन नंबर है, किसी भी तरह के अचानक खतरे, हमले या सुरक्षा की ज़रूरत होने पर फौरन इस नंबर पर कॉल करके पुलिस को मदद के लिए बुलाएं"},{"name":"Medical Emergency","number":"120","description":"यह चीन की राष्ट्रीय एम्बुलेंस सेवा का नंबर है, किसी भी मेडिकल इमरजेंसी या अचानक स्वास्थ्य खराब होने की स्थिति में इस नंबर पर कॉल करके तुरंत एम्बुलेंस बुलाई जा सकती है"},{"name":"Legal Aid Helpline","number":"12348","description":"यह चीन सरकार द्वारा चलाई जा रही मुफ्त कानूनी सहायता हेल्पलाइन है, यहाँ कॉल करके महिलाएं अपने अधिकारों और कानूनी समस्याओं के बारे में विशेषज्ञ सलाह ले सकती हैं"}]}]]
local defaultIndonesiaData = [[{"numbers":[{"name":"SAPA Helpline","number":"129","description":"यह इंडोनेशिया की खास हेल्पलाइन है जो महिलाओं और बच्चों के खिलाफ होने वाली हिंसा और दुर्व्यवहार की शिकायत दर्ज करने के लिए बनाई गई है, यहाँ कॉल करके आप फौरन सरकारी मदद मांग सकती हैं"},{"name":"Police Emergency","number":"110","description":"यह इंडोनेशिया पुलिस का मुख्य आपातकालीन नंबर है, किसी भी अचानक खतरे, हमले या सुरक्षा की ज़रूरत होने पर इस नंबर पर कॉल करके पुलिस को मदद के लिए बुलाएं"},{"name":"Emergency Common","number":"112","description":"यह इंडोनेशिया का मुख्य एकीकृत आपातकालीन नंबर है, यहाँ कॉल करके आप पुलिस, एम्बुलेंस और फायर ब्रिगेड तीनों की सहायता एक साथ प्राप्त कर सकती हैं"},{"name":"Medical Emergency","number":"119","description":"यह इंडोनेशिया की राष्ट्रीय स्वास्थ्य आपातकालीन सेवा है, किसी भी मेडिकल इमरजेंसी या अचानक तबीयत खराब होने की स्थिति में इस नंबर पर कॉल करके तुरंत एम्बुलेंस बुलाई जा सकती है"}]}]]
local defaultMalaysiaData = [[{"numbers":[{"name":"Talian Kasih","number":"15999","description":"यह मलेशिया सरकार की मुख्य सुरक्षा हेल्पलाइन है, जो महिलाओं और बच्चों को किसी भी तरह के दुर्व्यवहार या संकट के समय फौरन मदद प्रदान करती है, यह सेवा मुफ्त और 24 घंटे उपलब्ध है"},{"name":"WAO Hotline","number":"0326123444","description":"यह महिला सहायता संगठन की हेल्पलाइन है, जो घरेलू हिंसा की शिकार महिलाओं को शरण, कानूनी सलाह और मानसिक सहायता प्रदान करने का काम करती है"},{"name":"National Emergency","number":"999","description":"यह मलेशिया का मुख्य आपातकालीन नंबर है, किसी भी अचानक खतरे, दुर्घटना या पुलिस की ज़रूरत होने पर इस नंबर पर तुरंत कॉल करें"}]}]]
local defaultNigeriaData = [[{"numbers":[{"name":"Domestic Violence Hotline","number":"080000225522","description":"यह नाइजीरिया की राष्ट्रीय घरेलू हिंसा हेल्पलाइन है, यहाँ कॉल करके महिलाएं किसी भी तरह की घरेलू हिंसा या अत्याचार के खिलाफ सरकारी मदद और कानूनी सलाह ले सकती हैं"},{"name":"National Emergency","number":"112","description":"यह नाइजीरिया का मुख्य आपातकालीन नंबर है, किसी भी गंभीर खतरे या मुसीबत के समय इस नंबर पर कॉल करके पुलिस और एम्बुलेंस की मदद ली जा सकती है"}]}]]
local defaultSouthAfricaData = [[{"numbers":[{"name":"GBV Command Centre","number":"0800150150","description":"यह दक्षिण अफ्रीका का मुख्य जेंडर आधारित हिंसा केंद्र है, जो महिलाओं को किसी भी तरह के हमले या संकट के समय तुरंत सहायता और सुरक्षा प्रदान करता है"},{"name":"Police Emergency","number":"10111","description":"यह दक्षिण अफ्रीका पुलिस का मुख्य नंबर है, किसी भी अपराध की सूचना देने या सुरक्षा की ज़रूरत होने पर इस नंबर पर कॉल करके पुलिस को मदद के लिए बुलाएं"},{"name":"Mobile Emergency","number":"112","description":"यह मोबाइल फोन से लगाया जाने वाला आपातकालीन नंबर है, जो आपको तुरंत नज़दीकी आपातकालीन केंद्र से जोड़ देता है"},{"name":"Stop Gender Violence","number":"0800428428","description":"यह एक और महत्वपूर्ण हेल्पलाइन है जो महिलाओं के खिलाफ हिंसा को रोकने के लिए विशेषज्ञ सलाह और सहायता प्रदान करती है"}]}]]
local defaultUkraineData = [[{"numbers":[{"name":"Violence & Trafficking","number":"1547","description":"यह यूक्रेन की राष्ट्रीय हेल्पलाइन है जो घरेलू हिंसा, मानव तस्करी और लैंगिक भेदभाव के खिलाफ काम करती है, यहाँ कॉल करके महिलाएं मुफ्त कानूनी और मानसिक सहायता प्राप्त कर सकती हैं"},{"name":"Women Crisis Hotline","number":"116123","description":"यह महिलाओं के लिए एक अहम नेशनल हॉटलाइन है जो किसी भी तरह के संकट या असुरक्षा के समय मदद प्रदान करती है, यह सेवा पूरे यूक्रेन में मुफ्त उपलब्ध है"},{"name":"Police Emergency","number":"102","description":"यह यूक्रेन पुलिस का मुख्य आपातकालीन नंबर है, किसी भी अपराध की सूचना देने या अचानक खतरे के समय पुलिस की मदद के लिए तुरंत इस नंबर पर कॉल करें"},{"name":"Medical Emergency","number":"103","description":"यह यूक्रेन की राष्ट्रीय एम्बुलेंस सेवा का नंबर है, किसी भी गंभीर बीमारी या अचानक दुर्घटना के समय फौरन इस नंबर पर कॉल करके एम्बुलेंस मांगें"}]}]]
local defaultUSAData = [[{"numbers":[{"name":"Domestic Violence Hotline","number":"8007997233","description":"यह अमेरिका की राष्ट्रीय घरेलू हिंसा हेल्पलाइन है, अगर कोई महिला घर में असुरक्षित महसूस कर रही है या उसे किसी भी तरह की मदद चाहिए, तो इस नंबर पर कॉल करके तुरंत गोपनीय सहायता प्राप्त की जा सकती है"},{"name":"Sexual Assault Hotline","number":"8006564673","description":"यह नंबर यौन हमले और उत्पीड़न की शिकार महिलाओं को तुरंत सहायता और सलाह देने के लिए बनाया गया है, यहाँ विशेषज्ञ काउंसलर मदद के लिए हमेशा उपलब्ध रहते हैं"},{"name":"Human Trafficking Hotline","number":"8883737888","description":"यह अमेरिका की मानव तस्करी विरोधी हेल्पलाइन है, अगर किसी महिला को ज़बरदस्ती कहीं ले जाने या किसी गलत काम में धकेलने का शक हो, तो तुरंत इस नंबर पर सूचना दें"},{"name":"National Emergency","number":"911","description":"यह अमेरिका का मुख्य आपातकालीन नंबर है, किसी भी अचानक खतरे, दुर्घटना या पुलिस की ज़रूरत होने पर तुरंत 911 पर कॉल करें"},{"name":"Crisis Lifeline","number":"988","description":"यह अमेरिका की राष्ट्रीय मानसिक स्वास्थ्य और संकट हेल्पलाइन है, अगर आप बहुत ज़्यादा तनाव, घबराहट या निराशा महसूस कर रही हैं, तो यहाँ कॉल करके विशेषज्ञ से बात कर सकती हैं"}]}]]
local defaultUKData = [[{"numbers":[{"name":"Domestic Abuse Helpline","number":"08082000247","description":"यह बर्तानिया की राष्ट्रीय घरेलू दुर्व्यवहार हेल्पलाइन है, जो महिलाओं को घरेलू हिंसा से बचने के लिए 24 घंटे मुफ्त और गोपनीय सलाह और सहायता प्रदान करती है"},{"name":"Rape Crisis Helpline","number":"08088029999","description":"यह हेल्पलाइन उन महिलाओं के लिए जिन्होंने यौन हिंसा या हमले का सामना किया है, यहाँ विशेषज्ञ टीम आपको पूरी सहायता और कानूनी जानकारी प्रदान करेगी"},{"name":"National Emergency","number":"999","description":"यह बर्तानिया का मुख्य आपातकालीन नंबर है, किसी भी बड़ी मुसीबत, हमले या पुलिस और एम्बुलेंस की फौरन ज़रूरत होने पर इस नंबर पर कॉल करें"},{"name":"Non Emergency Police","number":"101","description":"यह पुलिस का गैर-आपातकालीन नंबर है, अगर कोई अपराध हो चुका है और आपको केवल उसकी रिपोर्ट दर्ज करानी है या पुलिस से सलाह लेनी है, तो इस नंबर का इस्तेमाल करें"},{"name":"NHS Health Advice","number":"111","description":"यह बर्तानिया की राष्ट्रीय स्वास्थ्य सेवा का नंबर है, अगर आपकी तबीयत अचानक खराब है और आपको डॉक्टर की सलाह चाहिए लेकिन यह कोई बड़ा आपातकालीन मामला नहीं है, तो यहाँ कॉल करें"}]}]]

local function showError(msg)
service.speak(msg)
pcall(function() Toast.makeText(service, msg, 1).show() end)
end

local function readConfigFile()
local file = io.open(CONFIG_PATH, "r")
if not file then return nil end
local content = file:read("*a")
file:close()
return content
end

local function writeConfigFile(jsonString)
Thread(Runnable({
run = function()
pcall(function()
local f = File(CONFIG_PATH)
local fos = FileOutputStream(f)
fos.write(String(jsonString).getBytes())
fos.close()
end)
end
})).start()
end

local function getHealthData()
local jsonStr = readConfigFile()
if not jsonStr or jsonStr == "" then return nil, 28 end
local status, resMillis, resCycle = pcall(function()
local rootJson = JSONObject(jsonStr)
if rootJson.has("healthData") then
local data = rootJson.getJSONObject("healthData")
local ms = data.optString("dateMillis", "")
if ms == "" then ms = nil end
return ms, tonumber(data.optString("cycle", "28")) or 28
end
return nil, 28
end)
if status then return resMillis, resCycle else return nil, 28 end
end

local function saveHealthData(dateMillis, cycleLength)
local rootJson = JSONObject()
local jsonStr = readConfigFile()
if jsonStr and jsonStr ~= "" then pcall(function() rootJson = JSONObject(jsonStr) end) end
local dataJson = JSONObject()
if dateMillis then dataJson.put("dateMillis", tostring(dateMillis)) end
dataJson.put("cycle", tostring(cycleLength))
rootJson.put("healthData", dataJson)
writeConfigFile(rootJson.toString())
end

local function getOfflineHelpline(country)
local jsonStr = readConfigFile()
if not jsonStr or jsonStr == "" then return nil end
local status, res = pcall(function()
local rootJson = JSONObject(jsonStr)
if rootJson.has("helplineCache") then
local cache = rootJson.getJSONObject("helplineCache")
if cache.has(country) then return cache.getJSONObject(country) end
end
return nil
end)
if status then return res else return nil end
end

local function saveHelplineOffline(country, dataJsonObj)
local rootJson = JSONObject()
local jsonStr = readConfigFile()
if jsonStr and jsonStr ~= "" then pcall(function() rootJson = JSONObject(jsonStr) end) end
local cache = JSONObject()
if rootJson.has("helplineCache") then cache = rootJson.getJSONObject("helplineCache") end
cache.put(country, dataJsonObj)
rootJson.put("helplineCache", cache)
writeConfigFile(rootJson.toString())
end

local currentVersion = 1.0
local showHealthTracker, showMainMenu, openManualDateDialog, showCountryList, showHelplines, showNumberDetail, showHelplinesDialog, checkUpdate

showNumberDetail = function(name, number, description, country)
local builder = AlertDialog.Builder(service)
builder.setTitle(name)
local layout = LinearLayout(service)
layout.setOrientation(1)
layout.setPadding(40, 40, 40, 40)
local scroll = ScrollView(service)
local tvDesc = TextView(service)
tvDesc.setText("नंबर, " .. number .. ",\n\nपूरी जानकारी,\n" .. description)
tvDesc.setTextSize(18)
tvDesc.setTextColor(0xFF000000)
scroll.addView(tvDesc)
layout.addView(scroll)
local dialog
local btnCall = Button(service)
btnCall.setText("Call Now")
btnCall.setAllCaps(false)
layout.addView(btnCall)
local btnBack = Button(service)
btnBack.setText("Go Back")
btnBack.setAllCaps(false)
layout.addView(btnBack)
builder.setView(layout)
dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
btnCall.setOnClickListener(function()
local intent = Intent(Intent.ACTION_DIAL, Uri.parse("tel:" .. number))
intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
service.startActivity(intent)
if dialog then dialog.dismiss() end
end)
btnBack.setOnClickListener(function()
if dialog then dialog.dismiss() end
showHelplines(country)
end)
dialog.show()
end

showHelplinesDialog = function(country, dataJsonObj)
local names = {}
local numbers = dataJsonObj.getJSONArray("numbers")
for i = 0, numbers.length() - 1 do
local item = numbers.getJSONObject(i)
table.insert(names, item.getString("name") .. " (" .. item.getString("number") .. ")")
end
local builder = AlertDialog.Builder(service)
builder.setTitle(country .. " Official Women Helplines")
builder.setItems(names, DialogInterface.OnClickListener{
onClick = function(d, w)
local selected = numbers.getJSONObject(w)
showNumberDetail(selected.getString("name"), selected.getString("number"), selected.getString("description"), country)
end
})
builder.setNegativeButton("Go Back", function() showCountryList() end)
local listDialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then listDialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else listDialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
listDialog.show()
end

showHelplines = function(country)
local offlineData = getOfflineHelpline(country)
if not offlineData then
local defaultDataMap = {["India"]=defaultIndiaData, ["Pakistan"]=defaultPakistanData, ["Bangladesh"]=defaultBangladeshData, ["Nepal"]=defaultNepalData, ["Sri Lanka"]=defaultSriLankaData, ["China"]=defaultChinaData, ["Indonesia"]=defaultIndonesiaData, ["Malaysia"]=defaultMalaysiaData, ["Nigeria"]=defaultNigeriaData, ["South Africa"]=defaultSouthAfricaData, ["UK"]=defaultUKData, ["Ukraine"]=defaultUkraineData, ["USA"]=defaultUSAData}
if defaultDataMap[country] then pcall(function() offlineData = JSONObject(defaultDataMap[country]) end) end
end
if not offlineData then
service.speak("डेटा लोड हो रहा है, इंतज़ार करें")
Http.get(HELPLINE_URL, nil, "utf-8", nil, function(code, res)
if code == 200 and res then
local status, jsonObj = pcall(function() return JSONObject(res).getJSONObject(country) end)
if status then
saveHelplineOffline(country, jsonObj)
showHelplinesDialog(country, jsonObj)
else
showError("इस मुल्क का डेटा मौजूद नहीं है")
end
else
showError("इंटरनेट कनेक्शन काम नहीं कर रहा है")
end
end)
else
showHelplinesDialog(country, offlineData)
Http.get(HELPLINE_URL, nil, "utf-8", nil, function(code, res)
if code == 200 and res then
pcall(function()
local onlineJson = JSONObject(res).getJSONObject(country)
if onlineJson.toString() ~= offlineData.toString() then
saveHelplineOffline(country, onlineJson)
end
end)
end
end)
end
end

showCountryList = function()
local countries = {"India", "Pakistan", "Bangladesh", "Nepal", "Sri Lanka", "China", "Indonesia", "Malaysia", "Nigeria", "South Africa", "UK", "Ukraine", "USA"}
local builder = AlertDialog.Builder(service)
builder.setTitle("Choose Country")
builder.setItems(countries, DialogInterface.OnClickListener{
onClick = function(d, w)
showHelplines(countries[w+1])
end
})
builder.setNegativeButton("Go Back", function() showMainMenu() end)
local dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dialog.show()
end

openManualDateDialog = function(currentCycle)
local bInput = AlertDialog.Builder(service)
bInput.setTitle("Advance Women Helper")
local layout = LinearLayout(service)
layout.setOrientation(1)
layout.setPadding(30, 30, 30, 30)
local editDate = luajava.bindClass("android.widget.EditText")(service)
editDate.setHint("dd-mm-yyyy")
editDate.setInputType(4)
local InputFilter = luajava.bindClass("android.text.InputFilter")
local LengthFilter = luajava.bindClass("android.text.InputFilter$LengthFilter")
local filterArray = luajava.newArray(InputFilter, 1)
filterArray[0] = LengthFilter(10)
editDate.setFilters(filterArray)
local isFormatting = false
editDate.addTextChangedListener(luajava.bindClass("android.text.TextWatcher"){
beforeTextChanged = function(s, start, count, after) end,
onTextChanged = function(s, start, before, count) end,
afterTextChanged = function(s)
if isFormatting then return end
isFormatting = true
local str = s.toString():gsub("[^0-9]", "")
if string.len(str) == 8 and string.len(s.toString()) ~= 10 then
local formatted = string.sub(str, 1, 2) .. "-" .. string.sub(str, 3, 4) .. "-" .. string.sub(str, 5, 8)
editDate.setText(formatted)
editDate.setSelection(string.len(formatted))
end
isFormatting = false
end
})
local btnCalendar = Button(service)
btnCalendar.setText("Open Calendar")
btnCalendar.setAllCaps(false)
local lpCal = LinearLayout.LayoutParams(-1, -2)
lpCal.setMargins(0, 0, 0, 30)
btnCalendar.setLayoutParams(lpCal)
btnCalendar.setOnClickListener(function(v)
local cal = Calendar.getInstance()
local selD = tostring(cal.get(Calendar.DAY_OF_MONTH))
local selM = cal.get(Calendar.MONTH) + 1
local selY = tostring(cal.get(Calendar.YEAR))
local bCust = AlertDialog.Builder(service)
bCust.setTitle("Select Date")
local lCust = LinearLayout(service)
lCust.setOrientation(1)
lCust.setPadding(30, 30, 30, 30)
local btnD = Button(service)
btnD.setText(selD .. " (Day)")
btnD.setAllCaps(false)
local btnM = Button(service)
local gMonths = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
btnM.setText(gMonths[selM] .. " (Month)")
btnM.setAllCaps(false)
local btnY = Button(service)
btnY.setText(selY .. " (Year)")
btnY.setAllCaps(false)
lCust.addView(btnD)
lCust.addView(btnM)
lCust.addView(btnY)
btnD.setOnClickListener(function()
local days = {}
for i = 1, 31 do table.insert(days, tostring(i)) end
local dDialog = AlertDialog.Builder(service)
dDialog.setItems(days, DialogInterface.OnClickListener{
onClick = function(dd, wd)
selD = days[wd+1]
btnD.setText(selD .. " (Day)")
dd.dismiss()
end
})
local dObj = dDialog.create()
if Build.VERSION.SDK_INT >= 22 then dObj.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dObj.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dObj.show()
end)
btnM.setOnClickListener(function()
local mDialog = AlertDialog.Builder(service)
mDialog.setItems(gMonths, DialogInterface.OnClickListener{
onClick = function(dm, wm)
selM = wm + 1
btnM.setText(gMonths[selM] .. " (Month)")
dm.dismiss()
end
})
local mObj = mDialog.create()
if Build.VERSION.SDK_INT >= 22 then mObj.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else mObj.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
mObj.show()
end)
btnY.setOnClickListener(function()
local years = {}
for y = 2020, 2030 do table.insert(years, tostring(y)) end
local yDialog = AlertDialog.Builder(service)
yDialog.setItems(years, DialogInterface.OnClickListener{
onClick = function(dy, wy)
selY = years[wy+1]
btnY.setText(selY .. " (Year)")
dy.dismiss()
end
})
local yObj = yDialog.create()
if Build.VERSION.SDK_INT >= 22 then yObj.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else yObj.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
yObj.show()
end)
local btnDone = Button(service)
btnDone.setText("Done")
btnDone.setAllCaps(false)
local lpDone = LinearLayout.LayoutParams(-1, -2)
lpDone.setMargins(0, 30, 0, 0)
btnDone.setLayoutParams(lpDone)
lCust.addView(btnDone)
bCust.setView(lCust)
local dCust = bCust.create()
if Build.VERSION.SDK_INT >= 22 then dCust.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dCust.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
btnDone.setOnClickListener(function()
local finalDate = string.format("%02d-%02d-%04d", tonumber(selD), selM, tonumber(selY))
editDate.setText(finalDate)
dCust.dismiss()
end)
dCust.show()
end)
local btnSave = Button(service)
btnSave.setText("Save Date")
btnSave.setAllCaps(false)
btnSave.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
local btnGoBack = Button(service)
btnGoBack.setText("Go Back")
btnGoBack.setAllCaps(false)
btnGoBack.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
layout.addView(editDate)
layout.addView(btnCalendar)
layout.addView(btnSave)
layout.addView(btnGoBack)
bInput.setView(layout)
local dInput = bInput.create()
if Build.VERSION.SDK_INT >= 22 then dInput.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dInput.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dInput.show()
btnGoBack.setOnClickListener(function(v)
dInput.dismiss()
showHealthTracker()
end)
btnSave.setOnClickListener(function(btnV)
local rawInput = editDate.getText().toString()
local cleanDate = rawInput:gsub("[^0-9]", "")
if string.len(cleanDate) ~= 8 then
showError("Please enter a valid date")
return
end
local pDay, pMonth, pYear = cleanDate:sub(1,2), cleanDate:sub(3,4), cleanDate:sub(5,8)
local formatter = SimpleDateFormat("dd-MM-yyyy", Locale.getDefault())
local status, dateObj = pcall(function() return formatter.parse(pDay .. "-" .. pMonth .. "-" .. pYear) end)
if status and dateObj then
saveHealthData(dateObj.getTime(), currentCycle)
service.speak("तारीख महफूज़ हो गई है")
dInput.dismiss()
Handler(Looper.getMainLooper()).postDelayed(Runnable({run = function() showHealthTracker() end}), 200)
else
showError("Please enter a valid date")
end
end)
end

showHealthTracker = function()
local lastDateMillis, cycleLength = getHealthData()
cycleLength = cycleLength or 28
local statusText, nextDateText = "", ""
local cycleBtnText = "Choose Cycle Days (" .. cycleLength .. ")"
local dateBtnText = "Set Last Period Date (Not Set)"
if lastDateMillis then
local lastTime = tonumber(lastDateMillis)
local currentTime = Calendar.getInstance().getTimeInMillis()
local diff = currentTime - lastTime
local daysPassed = math.floor(diff / (1000 * 60 * 60 * 24))
local daysLeft = cycleLength - daysPassed
local displayFormatter = SimpleDateFormat("dd MMMM yyyy", Locale.ENGLISH)
local lastDateStr = displayFormatter.format(Date(lastTime))
dateBtnText = "Set Last Period Date (" .. lastDateStr .. ")"
local nextTime = lastTime + (cycleLength * 24 * 60 * 60 * 1000)
local nextDateStr = displayFormatter.format(Date(nextTime))
statusText = "आपका पिछला पीरियड " .. lastDateStr .. " को था (" .. daysPassed .. " दिन पहले)"
if daysLeft > 0 then
nextDateText = "अगला पीरियड " .. nextDateStr .. " को हो सकता है (" .. daysLeft .. " दिन बाकी)"
else
nextDateText = "अगला पीरियड " .. nextDateStr .. " को हो सकता है (तारीख गुज़र चुकी है या आज ही है)"
end
else
statusText = "अभी आपका कोई डेटा यहाँ मौजूद नहीं है, अपने आने वाले पीरियड का सही पता लगाने के लिए 'Set Last Period Date' से अपने पिछले पीरियड की तारीख सेट करें और 'Choose Cycle Days' से अपना साइकिल बताएं"
nextDateText = ""
end
local builder = AlertDialog.Builder(service)
builder.setTitle("Advance Women Helper")
local layout = LinearLayout(service)
layout.setOrientation(1)
layout.setPadding(40, 40, 40, 40)
local tvStatus = TextView(service)
if nextDateText == "" then
tvStatus.setText(statusText)
else
tvStatus.setText(statusText .. "\n\n" .. nextDateText)
end
tvStatus.setTextSize(18)
tvStatus.setTextColor(0xFF000000)
layout.addView(tvStatus)
local btnSetCycle = Button(service)
btnSetCycle.setText(cycleBtnText)
btnSetCycle.setAllCaps(false)
btnSetCycle.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
layout.addView(btnSetCycle)
local btnManualDate = Button(service)
btnManualDate.setText(dateBtnText)
btnManualDate.setAllCaps(false)
btnManualDate.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
layout.addView(btnManualDate)
local btnBack = Button(service)
btnBack.setText("Go Back")
btnBack.setAllCaps(false)
btnBack.setLayoutParams(LinearLayout.LayoutParams(-1, -2))
layout.addView(btnBack)
builder.setView(layout)
local dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
btnSetCycle.setOnClickListener(function()
local cycles = {}
local selectedIdx = 0
for i = 20, 35 do
table.insert(cycles, tostring(i))
if i == cycleLength then selectedIdx = i - 20 end
end
local bCycle = AlertDialog.Builder(service)
bCycle.setTitle("Select Cycle Days")
bCycle.setSingleChoiceItems(cycles, selectedIdx, DialogInterface.OnClickListener{
onClick = function(dCycle, wCycle)
local newCycle = tonumber(cycles[wCycle+1])
saveHealthData(lastDateMillis, newCycle)
service.speak("साइकिल महफूज़ हो गया है")
dCycle.dismiss()
dialog.dismiss()
Handler(Looper.getMainLooper()).postDelayed(Runnable({run = function() showHealthTracker() end}), 200)
end
})
local dCycle = bCycle.create()
if Build.VERSION.SDK_INT >= 22 then dCycle.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dCycle.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dCycle.show()
end)
btnManualDate.setOnClickListener(function()
dialog.dismiss()
openManualDateDialog(cycleLength)
end)
btnBack.setOnClickListener(function()
dialog.dismiss()
showMainMenu()
end)
dialog.show()
end

showMainMenu = function()
local menuOptions = {"Women Helplines", "Health & Period Tracker", "Check for Update"}
local bMenu = AlertDialog.Builder(service)
bMenu.setTitle("Advance Women Helper (v" .. currentVersion .. ")")
bMenu.setItems(menuOptions, DialogInterface.OnClickListener{
onClick = function(d, w)
d.dismiss()
if w == 0 then showCountryList()
elseif w == 1 then showHealthTracker()
elseif w == 2 then checkUpdate(true) end
end
})
bMenu.setNegativeButton("Close", nil)
local dMenu = bMenu.create()
if Build.VERSION.SDK_INT >= 22 then dMenu.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dMenu.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dMenu.show()
dMenu.getButton(DialogInterface.BUTTON_NEGATIVE).setAllCaps(false)
end

checkUpdate = function(isManual)
if isManual then
service.speak("चेक किया जा रहा है, इंतज़ार करें")
end
Http.get("https://raw.githubusercontent.com/hafiztasleem85-cmyk/Advance-women-helper/refs/heads/main/version.txt", nil, "utf-8", nil, function(code, res)
if code == 200 and res then
local onlineVersion = tonumber(res)
if onlineVersion and onlineVersion > currentVersion then
Http.get("https://raw.githubusercontent.com/hafiztasleem85-cmyk/Advance-women-helper/refs/heads/main/Notes.txt", nil, "utf-8", nil, function(codeNotes, resNotes)
local updateMessage = "नया अपडेट मौजूद है"
if codeNotes == 200 and resNotes then
updateMessage = resNotes
end
local builder = AlertDialog.Builder(service)
builder.setTitle("Update Available")
builder.setMessage(updateMessage)
builder.setPositiveButton("Update Now", function()
service.speak("अपडेट हो रहा है, इंतज़ार करें")
Http.get("https://raw.githubusercontent.com/hafiztasleem85-cmyk/Advance-women-helper/refs/heads/main/update.lua", nil, "utf-8", nil, function(code2, res2)
if code2 == 200 and res2 then
local path = service.getPluginPath()
if not path:match("%.lua$") then path = path .. "/main.lua" end
local f = io.open(path, "w")
if f then
f:write(res2)
f:close()
service.speak("प्लगइन कामयाबी के साथ अपडेट हो गया है")
else
service.speak("अपडेट महफूज़ करने में दिक्कत आई")
showMainMenu()
end
else
service.speak("अपडेट डाउनलोड नहीं हो सका")
showMainMenu()
end
end)
end)
builder.setNegativeButton("Later", function() showMainMenu() end)
local dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dialog.show()
end)
else
if isManual then
local msg = "आप पहले से ही बेहतरीन और नए वर्ज़न " .. currentVersion .. " का इस्तेमाल कर रहे हैं"
service.speak(msg)
local builder = AlertDialog.Builder(service)
builder.setTitle("Advance Women Helper")
builder.setMessage(msg)
builder.setPositiveButton("OK", function() showMainMenu() end)
local dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dialog.show()
else
showMainMenu()
end
end
else
if isManual then
local msg = "इंटरनेट कनेक्शन काम नहीं कर रहा है"
service.speak(msg)
local builder = AlertDialog.Builder(service)
builder.setTitle("Advance Women Helper")
builder.setMessage(msg)
builder.setPositiveButton("OK", function() showMainMenu() end)
local dialog = builder.create()
if Build.VERSION.SDK_INT >= 22 then dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY) else dialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT) end
dialog.show()
else
showMainMenu()
end
end
end)
end

checkUpdate(false)
return true
