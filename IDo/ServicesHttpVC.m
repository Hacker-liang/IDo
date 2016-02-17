//
//  ServicesHttpVC.m
//  IDo
//
//  Created by 柯南 on 16/2/17.
//  Copyright © 2016年 com.Yinengxin.xianne. All rights reserved.
//

#import "ServicesHttpVC.h"

@interface ServicesHttpVC ()<UITextViewDelegate>
@property (nonatomic,strong) UIScrollView *serviceSV;
@property (nonatomic,strong) NSString *contentStr1;
@property (nonatomic,strong) NSString *contentStr2;
@property (nonatomic,strong) NSString *contentStr3;
@property (nonatomic,strong) NSString *contentStr4;
@property (nonatomic,strong) NSString *contentStr5;
@property (nonatomic,strong) NSString *contentStr6;
@property (nonatomic,strong) NSString *contentStr7;
@property (nonatomic,strong) NSString *contentStr8;
@property (nonatomic,strong) NSString *contentStr9;
@property (nonatomic,strong) NSString *contentStr10;
@property (nonatomic,strong) NSString *contentStr11;
@property (nonatomic,strong) NSString *contentStr12;
@property (nonatomic,strong) NSString *contentStr13;
@property (nonatomic,strong) NSString *contentStr14;

@end

@implementation ServicesHttpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=APP_PAGE_COLOR;
    self.navigationItem.title = @"服务协议";
    self.edgesForExtendedLayout=0;
    
    _contentStr1=@"软件注册协议\n\n1.特别提示\n1.1\n本《软件注册协议》（以下简称《协议》）是服务使用人（以下简称“用户”）与北京意能行智能科技有限公司（以下简称“本公司”或者“我们”）之间关于用户下载、安装、使用本软件（ 包括但不限于PC版及移动电话、PDA版等各种无线手持终端版本的本软件）；注册、使用、管理本软件号；以及使用本公司提供的相关服务所订立的协议。\n1.2\n本软件由北京意能行智能科技有限公司研发，并同意按照本协议的规定及其不时发布的操作规则提供基于互联网以及移动网的相关服务（以下称“网络服务”） 。为获得网络服务，用户应认真阅读、充分理解本《协议》中各条款，特别涉及免除或者限制本公司责任的免责条款，对用户的权利限制的条款、约定争议解决方式、司法管辖、法律适用的条款。请您审慎阅读并选择勾选接受或不接受本《协议》（无民事行为能力人、限制民事行为能力人应在法定监护人陪同下阅读）。除非您接受本《协议》所有条款，否则您无权下载、安装或使用本软件及其相关服务。您的下载、安装、使用、帐号获取和登录等行为将视为对本《协议》的接受，并同意接受本《协议》各项条款的约束。\n1.3\n用户注册成功后，本公司将给予每个用户一个用户帐号，该账号与用户使用本软件的手机号码一致，该帐号归本公司所有，用户完成申请注册手续后，获得帐号的使用权。帐号使用权仅属于初始申请注册人，禁止赠与、借用、租用、转让或售卖。用户承担帐号与密码的保管责任，并就其帐号及密码项下之一切活动负全部责任。\n\n2.知识产权声明\n2.1\n本软件是由本公司开发。本软件的一切版权、商标权、专利权、商业秘密等知识产权，以及相关的所有信息内容，包括但不限于：文字表述及其组合、图标、图饰、图表、色彩、界面设计、版面框架、有关数据、印刷材料、或电子文档等均受中华人民共和国著作权法、商标法、专利法、反不正当竞争法和相应的国际条约以及其他知识产权法律法规的保护，除涉及第三方授权的软件或技术外，本公司享有上述知识产权。\n2.2\n未经本公司书面同意，用户不得为任何营利性或非营利性的目的自行实施、利用、转让或许可任何三方实施、利用、转让上述知识产权，本公司保留追究上述未经许可行为的权利。\n\n3.授权范围\n3.1\n用户可以为非商业目的在单一台终端设备上安装、使用、显示、运行本软件。用户不得为商业运营目的安装、使用、运行本软件，不可以对本软件或者本软件运行过程中释放到任何计算机终端内存中的数据及本软件运行过程中客户端与服务器端的交互数据进行复制、更改、修改、挂接运行或创作任何衍生作品，形式包括但不限于使用插件、外挂或非经授权的第三方工具/服务接入本软件和相关系统。\n3.2\n用户不得未经本公司书面许可，将本软件安装在未经本公司明示许可的其他终端设备上，包括但不限于机顶盒、无线上网机、游戏机、电视机等。\n3.3\n保留权利：未明示授权的其他一切权利仍归本公司所有，用户使用其他权利时须另外取得本公司的书面同意。\n\n4.服务内容\n4.1\n本软件所提供服务的具体内容由本公司根据实际情况提供，主要包括发单方和抢单方用户的注册登录、任务需求发布、有偿抢收订单、实时聊天通讯、订单完成后评价及举报投诉、查询订单历史记录等。\n4.2\n本软件提供的部分网络服务为收费的网络服务，用户使用收费网络服务需要向本公司支付一定的费用。对于收费的网络服务，我们会尽量在用户使用之前给予用户明确的提示，只有用户根据提示确认其愿意支付相关费用，用户才能使用该等收费网络服务。如用户拒绝支付相关费用，则本公司有权不向用户提供该等收费网络服务。\n4.3\n用户理解，本公司仅提供相关的网络服务，除此之外与相关网络服务有关的设备（如个人电脑、手机、其他与接入互联网或移动网有关的装置）及第三方收取的相关费用（如为接入互联网而支付的电话费及上网费、为使用移动网而支付的手机费）均应由用户自行负担。\n\n5.服务变更、中断或终止\n5.1\n鉴于网络服务的特殊性，用户同意本公司有权随时变更、中断或终止部分或全部的网络服务（包括收费网络服务及免费网络服务）。如变更、中断或终止的网络服务属于免费网络服务，本公司无需通知用户，也无需对任何用户或任何第三方承担任何责任；如变更、中断或终止的网络服务属于收费网络服务，本公司应当在变更、中断或终止之前事先通知用户，并应向受影响的用户提供等值的替代性的收费网络服务，如用户不愿意接受替代性的收费网络服务，就该用户已经向本公司支付的服务费，本公司应当按照该用户实际使用相应收费网络服务的情况扣除相应服务费之后将剩余的服务费退还给该用户。\n5.2\n用户理解，本公司需要定期或不定期地对提供网络服务的平台（如互联网网站、移动网络等）或相关的设备进行检修或者维护，如因此类情况而造成收费网络服务在合理时间内的中断，本公司无需为此承担任何责任，且除特殊情况外应当事先进行通告。\n5.3\n如发生下列任何一种情形，本公司有权随时中断或终止向用户提供本协议项下的网络服务【该网络服务包括但不限于收费及免费网络服务（其中包括基于广告模式的免费网络服务）】而无需对用户或任何第三方承担任何责任： \n5.3.1用户提供的个人资料不真实； \n5.3.2用户违反本协议中规定的使用规则； \n5.3.3用户在使用收费网络服务时未按规定向本公司支付相应的服务费；\n5.3.4国家法律法规或行政命令干涉；\n5.4\n如用户注册的免费网络服务的帐号在任何连续60日内未实际使用，或者用户注册的收费网络服务的帐号在其订购的收费网络服务的服务期满之后连续90日内未实际使用，则本公司有权删除该帐号并停止为该用户提供相关的网络服务。\n5.5\n用户注册的免费帐号昵称和姓名如存在违反法律法规或国家政策要求，或侵犯任何第三方合法权益的情况，本公司有权禁止用户继续使用该帐号、昵称。\n\n6.使用规则\n6.1\n发单派单用户在申请使用本网络服务时，必须向本公司提供准确、真实的个人相关资料，且需要通过人工认证方能开始使用软件。如个人资料有任何变动，必须及时更新。更新后，本公司有权暂停该用户的使用权，同时需要人工再次认证方能继续使用软件。\n6.2\n用户不应将其帐号、密码转让或出借予他人使用。如用户发现其帐号遭他人非法使用，应立即通知本公司。因黑客行为或用户的保管疏忽导致帐号、密码遭他人非法使用，本公司不承担任何责任。\n6.3\n用户同意本公司有权在提供网络服务过程中以各种方式投放各种商业性广告或其他任何类型的商业信息，并且，用户同意接受本公司通过电子邮件或其他方式向用户发送商品促销或其他相关商业信息。\n6.4\n用户在使用本服务过程中，必须遵循以下原则： \n6.4.1遵守中国有关的法律和法规； \n6.4.2遵守所有与网络服务有关的网络协议、规定和程序； \n6.4.3不得为任何非法目的而使用网络服务系统； \n6.4.4不得以任何形式使用本服务侵犯本公司的商业利益，包括并不限于发布非经本公司许可的商业广告； \n6.4.5不得利用本网络服务系统进行任何可能对互联网或移动网正常运转造成不利影响的行为 \n6.4.6不得利用本产品提供的网络服务上传、展示或传播任何虚假的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、庸俗淫秽的或其他任何非法的信息资料； \n6.4.7不得侵犯其他任何第三方的专利权、著作权、商标权、名誉权或其他任何合法权益； \n6.4.8不得利用本服务系统进行任何不利于本公司的行为。\n本公司针对某些特定的本网络服务的使用通过各种方式（包括但不限于网页公告、电子邮件、短信提醒等）作出的任何声明、通知、警示等内容视为本协议的一部分，用户如使用该网络服务，视为用户同意该等声明、通知、警示的内容。\n6.5\n本公司有权对用户使用本网络服务【该网络服务包括但不限于收费及免费网络服务（其中包括基于广告模式的免费网络服务）】的情况进行审查和监督(包括但不限于对用户存储在本公司的内容进行审核)，如用户在使用网络服务时违反任何上述规定，本公司有权要求用户改正或直接采取一切必要的措施（包括但不限于更改或删除用户张贴的内容等、暂停或终止用户使用网络服务的权利）以减轻用户不当行为造成的影响。因用户自身行为需向第三人承担责任的，由用户自行承担，与本公司无关。\n\n7.本管理规定\n7.1\n用户注册本账号，注册内容、发单抢单的各种信息，应当为信息的真实性负责。同时用户应当使用真实身份信息，不得以虚假、冒用的居民身份信息、企业注册信息、组织机构代码信息进行注册。\n7.2\n抢单用户使用本软件期间，需保证本软件每周中至少有5天保持10小时的在线时间。\n7.3\n抢单用户使用本软件期间，需确保每月成功抢单20单。\n7.4\n抢单用户使用本软件期间，需诚信经营，不允许出现放鸽子行为\n7.5\n抢单用户在使用本软件期间，以不真实订单、违规刷单（以本公司软件后台的记录为准）骗取本公司奖励,本公司有权从抢单用户的注册账户中扣除等额于不真实订单、违规刷单骗取的金额并有权对抢单用户进行处罚。抢单用户以不真实订单、违规刷单骗取本公司奖励情节严重的本公司将保留追究法律责任的权利。\n7.6\n发单提供证据证明其支付错误，并经本公司与抢单用户沟通确认后，本公司可以协助抢单用户直接从其账户中将发单错付的费用返还给发单方。\n7.7\n本将建立健全用户信息安全管理制度、落实技术安全防控措施。本公司将对用户使用本网络服务过程中涉及的用户隐私内容加以保护。\n\n8.隐私保护\n8.1\n保护用户隐私是本公司的一项基本政策，本公司保证不对外公开或向第三方提供单个用户的注册资料及用户在使用网络服务时存储在本的非公开内容，但下列情况除外： \n8.1.1事先获得用户的明确授权； \n8.1.2根据有关的法律法规要求； \n8.1.3按照相关政府主管部门的要求； \n8.1.4为维护社会公众的利益； \n8.1.5为维护本公司的合法权益。\n8.2\n本可能会与第三方合作向用户提供相关的网络服务，在此情况下，如该第三方同意承担与本公司同等的保护用户隐私的责任，则本公司有权将用户的注册资料等提供给该第三方。\n8.3\n在不透露单个用户隐私资料的前提下，本公司有权对整个用户数据库进行分析并对用户数据库进行商业上的利用。 \n本公司《本软件对外隐私政策》作为本协议的有效组成部分，且您默许我公司不定时的更新隐私政策并接受。\n\n9.免责声明\n9.1\n本公司目前对注册用户均不进行实名认证，仅依靠注册用提供的手机号码作为唯一身份信息，本公司不掌握注册用户的真实身份信息，也没有义务和责任向第三方提供该用户的真实信息，注册用户在注册时应认真阅读本协议具体内容，并明确同意其使用本公司网络服务所发布或者接受的服务内容自行核实信息真假，并对所存在的风险将完全由其自己承担；因其使用本公司网络服务而产生的一切后果也由其自己承担，本公司对用户不承担任何责任。\n9.2\n本公司对网络服务不作任何类型的担保，包括但不限于网络服务的及时性、安全性、准确性，对在任何情况下因使用或不能使用本网络服务所产生的直接、间接、偶然、特殊及后续的损害及风险，本公司不承担任何责任。\n9.3\n对于不可抗力、计算机病毒、黑客攻击、系统不稳定、用户所在位置、用户关机以及其他任何网络、技术、通信线路等原因造成的服务中断或不能满足用户要求的风险，由用户自行承担，本公司不承担任何责任。\n9.4\n用户同意，对于本公司向用户提供的下列产品或者服务的质量缺陷本身及其引发的任何损失，本公司无需承担任何责任： \n9.4.1本公司向用户免费提供的各项网络服务； \n9.4.2本公司向用户赠送的任何产品或者服务； \n9.4.3本公司向收费网络服务用户附赠的各种产品或者服务。\n9.5\n用户（特别是抢单用户）同意，本公司所提供的功能受制于我国的现行法律法规和管理条例，即与本产品的功能和条例发生冲突时，应以各地的法律法规和管理条例为最高准则。任何通过本服务直接或间接违反法律法规和管理条例的行为，该后果应由用户承担。如有举证需要，本公司可以向有关部门提供相关数据作为证据。\n9.6\n用户（特别是抢单用户）理解对服务内容风险自担的重要性，且保证在任何可能引起安全隐患的情况下均不得使用本软件，并同意一切因使用本服务而导致的安全隐患和因此产生的纠纷和民事、刑事责任或事故，本公司概不负责赔偿。如有举证需要，本公司可以向有关部门提供相关数据作为证据。\n\n10.违约赔偿\n10.1\n如因本公司违反有关法律、法规或本协议项下的任何条款而给用户造成损失，本公司同意承担由此造成的损害赔偿责任。\n10.2\n用户同意保障和维护本公司及其他用户的利益，如因用户违反有关法律、法规或本协议项下的任何条款而给本公司或任何其他第三人造成损失，用户同意承担由此造成的损害赔偿责任。\n\n11.协议修改\n11.1\n本公司有权随时修改本协议的任何条款，一旦本协议的内容发生变动，本公司将会直接在本公司软件注册时或网站上公布修改之后的协议内容，该公布行为视为本公司已经通知用户修改内容。同时本公司也可通过其他适当方式向用户提示修改内容。\n11.2\n如果不同意本公司对本协议相关条款所做的修改，用户应当自行停止使用网络服务。如果用户继续使用网络服务，则视为用户接受本公司对本协议相关条款所做的修改。\n\n12.通知送达\n12.1\n本协议项下本公司对于用户所有的通知均可通过网页公告、电子邮件、手机短信或常规的信件传送等方式进行；该等通知于发送之日视为已送达收件人。\n12.2\n用户对于本公司的通知应当通过本公司对外正式公布的通信地址、传真号码、电子邮件地址等联系信息进行送达。该等通知以本公司实际收到日为送达日。\n\n13.法律管辖\n13.1\n本协议的订立、执行和解释及争议的解决均应适用中国法律并受中国法院管辖。\n13.2\n如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向本公司所在地的人民法院提起诉讼。\n\n14.其他规定\n14.1\n本协议构成双方对本协议之约定事项及其他有关事宜的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\n14.2\n本协议中的标题仅为方便而设，在解释本协议时应被忽略。\n\n本协议的最终解释权归北京意能行智能科技有限公司所有。";
    
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    _contentStr2=@"";
    
    _serviceSV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
//    _serviceSV.backgroundColor=[UIColor yellowColor];
    _serviceSV.contentSize=CGSizeMake(WIDTH, HEIGHT*12);
    [self.view addSubview:_serviceSV];
    
    UITextView *serviceTV=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT*12)];
    serviceTV.delegate=self;
    [_serviceSV addSubview:serviceTV];
    
    UILabel *serviceLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-20, HEIGHT*12)];
//    serviceLab.backgroundColor=[UIColor redColor];
    serviceLab.text=_contentStr1;
    serviceLab.numberOfLines=0;
    serviceLab.textAlignment=0;
    serviceLab.font=[UIFont systemFontOfSize:15];
    serviceLab.textColor=[UIColor lightGrayColor];
    [serviceTV addSubview:serviceLab];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
