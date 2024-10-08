# 1 ASCII中的控制字符的含义

|十进制|十六进制|控制字符|转义字符|说明|Ctrl + 下列字母|
|:---|:---|:---|:---|:---|:---|
|0|00|NUL|\0|Null character(空字符)|			@|
|1|01|SOH||Start of Header(标题开始)|		A|
|2|02|STX||	Start of Text(正文开始)	|		B|
|3|03|ETX||	 End of Text(正文结束)	|		C|
|4|04|EOT||	 End of Transmission(传输结束)|	D|
|5|05|ENQ||	 Enquiry(请求)			|		E|
|6|06|ACK|	| Acknowledgment(收到通知/响应)|	F|
|7|07|BEL|\a|Bell(响铃)					|	G|
|8|08|BS|\b|Backspace(退格)				|H|
|9|09|HT|\t|Horizontal Tab(水平制表符)		|I|
|10|0A|LF|\n|Line feed(换行键)				|J|
|11|0B|VT|\v|Vertical Tab(垂直制表符)		|	K|
|12|0C|FF|\f|Form feed(换页键)				|L|
|13|0D|CR|\r|Carriage return(回车键)			|M|
|14|0E|SO||	 Shift Out(不用切换)				|N|
|15|0F|SI||	 Shift In(启用切换)				|O|
|16|10|DLE||Data Link Escape(数据链路转义)	|P|
|17|11|DC1|	| Device Control 1(设备控制1) /XON(Transmit On)|	Q|
|18|12|DC2|	 |Device Control 2(设备控制2)		|R|
|19|13|DC3|	 |Device Control 3(设备控制3) /XOFF(Transmit Off)|	S|
|20|14|DC4|	 |Device Control 4(设备控制4)		|T|
|21|15|NAK|	 |Negative Acknowledgement(拒绝接收/无响应)|	U|
|22|16|SYN|	 |Synchronous Idle(同步空闲)		|V|
|23|17|ETB|	 |End of Trans the Block(传输块结束)	|W|
|24|18|CAN|	 |Cancel(取消)					|X|
|25|19|EM|	 |End of Medium(已到介质末端/介质存储已满)|	Y|
|26|1A|SUB|	 |Substitute(替补/替换)			|Z|
|27|1B|ESC|\e|Escape(溢出/逃离/取消)			|[|
|28|1C|FS|	 |File Separator(文件分割符)		|\|
|29|1D|GS|	 |Group Separator(分组符)		|]|
|30|1E|RS|	 |Record Separator(记录分隔符)	|^|
|31|1F|US|	 |Unit Separator(单元分隔符)		|\_|
|32|20|SP|	 |White space					|[Space]|
|127|7F|DEL||Delete(删除)					|?|

可以通过 “Ctrl+对应字母/按键”实现上述控制字符的输入

32=0x20，对应的是空格（Blank Space）键。不需要加Ctrl键，即可直接通过键盘上的空格键输入。

## 1.1 0 – NUL – NULl 字符/空字符

ASCII字符集中的空字符，NULL，起初本意可以看作为NOP（中文意为空操作），此位置可以忽略一个字符。之所以有这个空字符，主要是用于计算机早期的记录信息的纸带，此处留个NUL字符，意思是先占这个位置，以待后用，比如你哪天想起来了，在这个位置在放一个别的啥字符之类的。后来呢，NUL字符被用于C语言中，字符串的终结符，当一个字符串中间出现NUL/ NULL，代码里面表现为\0，的时候，就意味着这个是一个字符串的结尾了。这样就方便按照自己需求去定义字符串，多长都行，当然只要你内存放得下，然后最后加一个\0, 即空字符，意思是当前字符串到此结束。

## 1.2 1 – SOH – Start Of Heading 标题开始

如果信息沟通交流主要以命令和消息的形式的话，SOH就可以用于标记每个消息的开始。

1963年，最开始ASCII标准中，把此字符定义为Startof Message，后来又改为现在的Start Of Heading。现在，这个SOH常见于主从（master-slave）模式的RS232的通信中，一个主设备，以SOH开头，和从设备进行通信。这样方便从设备在数据传输出现错误的时候，在下一次通信之前，去实现重新同步（resynchronize）。如果没有一个清晰的类似于SOH这样的标记，去标记每个命令的起始或开头的话，那么重新同步，就很难实现了。

## 1.3 2 – STX – Start Of Text 文本开始

## 1.4 3 – ETX – End Of Text 文本结束

通过某种通讯协议去传输的一个数据（包），称为一帧的话，常会包含一个帧头，包含了寻址信息，即你是要发给谁，要发送到目的地是哪里，其后跟着真正要发送的数据内容。而STX，就用于标记这个数据内容的开始。接下来是要传输的数据，最后是ETX，表明数据的结束。其中，中间具体传输的数据内容，ASCII规范并没有去定义，其和你所用的传输协议，具体自己要传什么数据有关。

| 帧头                | 数据或文本内容                           |                     |                            |                     |
| ------------------- | ---------------------------------------- | ------------------- | -------------------------- | ------------------- |
| SOH（表明帧头开始） | ......（帧头信息，比如包含了目的地址等） | STX（表明数据开始） | ......（真正要传输的数据） | ETX（表明数据结束） |

总结一下：一般发送一个消息，包含了一个帧头和后面真正要传的数据。

## 1.5 4 – EOT – End Of Transmission 传输结束

## 1.6 5 – ENQ – ENQuiry 请求

## 1.7 6 – ACK – ACKnowledgment 回应/响应

## 1.8 7 – BEL – [audible] BELl

在ASCII字符集中，BEL，其原先本意不是用来数据编码的，于此相反，ASCII中的其他字符，都是用于字符编码（即用什么字符，代表什么含义）或者起到控制设备的作用。BEL用一个可以听得见的声音，来吸引人们的注意，其原打算即用于计算机也用于一些设备，比如打印机等。C语言里面也支持此BEL，用a来实现这个响铃。

## 1.9 8 – BS – BackSpace 退格键

退格键的功能，随着时间变化，意义也变得不同了。起初，意思是，在打印机和电传打字机上，往回移动一格光标，以起到强调该字符的作用。比如你想要打印一个a，然后加上退格键后，就成了aBS^。在机械类打字机上，此方法能够起到实际的强调字符的作用，但是对于后来的CTR下时期来说，就无法起到对应效果了。而现代所用的退格键，不仅仅表示光标往回移动了一格，同时也删除了移动后该位置的字符。在C语言中，退格键可以用b表示。

## 1.10 9 – HT – Horizontal Tab 水平制表符

ASCII中的HT控制符的作用是用于布局的。其控制输出设备前进到下一个表格去处理。而制表符Table/Tab的宽度也是灵活不固定的，只不过，多数设备上，制表符Tab的宽度都预定义为8。水平制表符HT不仅能减少数据输入者的工作量，对于格式化好的文字来说，还能够减少存储空间，因为一个Tab键，就代替了8个空格，所以说省空间。

对于省空间的优点，我们现在来看，可能会觉得可笑，因为现在存储空间已足够大，一般来说根本不会需要去省那么点可怜的存储空间。但是，实际上在计算机刚发明的时候，存储空间（主要指的是内存）极其有限也极其昂贵，而且像ZIP等压缩方法也还没发明呢，所以对于当时来说，对于存储空间，那是能够省一点是一点，省任何一点，都是好的，也都是不容易的，省空间就是省钱啊。

C语言中，用t表示制表符。

## 1.11 10 – LF – Line Feed 换行

LF，直译为（给打印机等）喂一行，意思就是所说的，换行。换行字符，是ASCII字符集中，被误用的字符中的其中一个。

LF的最原始的含义是，移动打印机的头到下一行。而另外一个ASCII字符，CR（Carriage Return）才是将打印机的头，移到最左边即一行的开始，行首。很多串口协议和MS-DOS及Windows操作系统，也都是这么实现的。而于此不同，对于C语言和Unix操作系统，其重新定义了LF字符的含义为新行，即LF和CR的组合才能表达出的，回车且换行的意思。

从程序的角度出发，C语言和Unix对此LF的含义实现显得就很自然，而MS-DOS的实现更接近于LF的本意。

LF表示物理上的，设备控制方面的移动到下一行（并没有移动到行首）；新行（newline）表示逻辑上文本分隔符，即回车换行。

LF在C语言中，用n表示。

## 1.12 11 – VT – Vertical Tab 垂直制表符

垂直制表符，类似于水平制表符Tab，目的是为了减少布局中的工作，同时也减少了格式化字符时所需要存储字符的空间。VT控制码用于跳到下一个标记行。

## 1.13 12 – FF – Form Feed 换页

设计换页键，是用来控制打印机行为的。当打印机收到此键码的时候，打印机移动到下一页。不同的设备的终端对此控制码所表现的行为各不同。有些会去清除屏幕，而其他有的只是显示^L字符或者是只是新换一行而已。

Shell脚本程序Bash和Tcsh的实现方式是，把FF看作是一个清除屏幕的命令。C语言程序中用f表示FF（换页）。

## 1.14 13 – CR – Carriage return 机器的滑动部分/底座 返回 -> 回车

CR回车的原意是让打印头回到左边界，并没有移动到下一行。随着时间流逝，后来人把CR的意思弄成了Enter键，用于示意输入完毕。在数据以屏幕显示的情况下，人们在Enter的同时，也希望把光标移动到下一行。

因此C语言和Unix操作系统，重新定义了LF的意思，使其表示为移动到下一行。当输入CR去存储数据的时候，软件也常常隐式地将其转换为LF。

## 1.15 14 – SO – Shift Out 不用切换

## 1.16 15 – SI – Shift In 启用切换

早在1960s年代，定义ASCII字符集的人，就已经懂得了，设计字符集不单单可以用于英文字符集，也要能应用于外文字符集，是很重要的。定义Shift In 和Shift Out的含义，即考虑到了此点。最开始，其意为在西里尔语和拉丁语之间切换。西里尔ASCII定义中，KOI-7用到了Shift字符。拉丁语用Shift去改变打印机的字体。在此种用途中，SO用于产生双倍宽度的字符，而用SI打印压缩的字体。

## 1.17 16 – DLE – Data Link Escape 数据链路转义

有时候，我们需要在正在进行的通信过程中去发送一些控制字符。但是，总有一些情况下，这些控制字符却被看成了普通的数据流，而没有起到对应的控制效果。而ASCII标准中，定义DLE来解决这类问题。如果数据流中检测到了DLE，数据接收端则对其后面接下来的数据流中的字符，另作处理。而关于具体如何处理这些字符，ASCII规范中则没有具体定义，而只是弄了个DLE去打断正常数据的处理，告诉接下来的数据，要特殊对待。

根据Modem中的Hayes通信协议DLE定义为“无声+++无声”。

## 1.18 17 – DC1 – Device Control 1 / XON – Transmission on

这个ASCII控制字符尽管原先定义为DC1， 但是现在常表示为XON，用于串行通信中的软件流控制。其主要作用为，在通信被控制码XOFF中断之后，重新开始信息传输。用过串行终端的人应该还记得，当有时候数据出错了，按Ctrl+Q（等价于XON）有时候可以起到重新传输的效果。这是因为，此Ctrl+Q键盘序列实际上就是产生XON控制码，其可以将那些由于终端或者主机方面，由于偶尔出现的错误的XOFF控制码而中断的通信解锁，使其正常通信。

## 1.19 18 – DC2 – Device Control 2

## 1.20 19 – DC3 – Device Control 3 / XOFF – Transmission off 传输中断

## 1.21 20 – DC4 – Device Control 4

## 1.22 21 – NAK – Negative AcKnowledgment 负面响应-> 无响应, 非正常响应

## 1.23 22 – SYN – SYNchronous idle

## 1.24 23 – ETB – End of Transmission Block 块传输中止

## 1.25 24 – CAN – CANcel 取消

## 1.26 25 – EM – End of Medium 已到介质末端，介质存储已满

EM用于，当数据存储到达串行存储介质末尾的时候，就像磁带或磁头滚动到介质末尾一样。其用于表述数据的逻辑终点，即不必非要是物理上的达到数据载体的末尾。

## 1.27 26 – SUB – SUBstitute character替补/替换

## 1.28 27 – ESC – ESCape 逃离/取消

字符Escape，是ASCII标准的首创的，由Bob Bemer提议的。用于开始一段控制码的扩展字符。如此，即可以不必将所有可能想得到的字符都放到ASCII标准中了。因为，新的技术可能需要新的控制命令，而ESC可以用作这些字符命令的起始标志。ESC广泛用于打印机和终端，去控制设备设置，比如字体，字符位置和颜色等等。

如果最开始的ASCII标准中，没有定义ESC，估计ASCII标准早就被其他标准所替代了，因为其没有包含这些新出现的字符，所以肯定会有其他新的标准出现，用于表示这些字符的。

即，ESC给开发者提供了，可以根据需要而定义新含义的字符的可能。

## 1.29 28 – FS – File Separator 文件分隔符

文件分隔符是个很有意思的控制字符，因为其可以让我们看到1960s年代的时候，计算机技术是如何组织的。我们现在，习惯于随即访问一些存储介质，比如RAM，磁盘，但是在定义ASCII标准的那个年代，大部分数据还是顺序的，串行的，而不是随机访问的。此处所说的串行的，不仅仅指的是串行通信，还指的是顺序存储介质，比如穿孔卡片，纸带，磁带等。

在串行通信的时代，设计这么一个用于表示文件分隔符的控制字符，用于分割两个单独的文件，是一件很明智的事情。而FS的原因就在于此。

## 1.30 29 – GS – Group Separator分组符

ASCII定义控制字符的原因中，其中一条就是考虑到了数据存储方面的情况。大部分情况下，数据库的建立，都和表有关，包含了对应的记录。同一个表中的所有的记录，属于同一类型。不同的表中的记录，属于对应的不同的类型。而分组符GS就是用来分隔串行数据存储系统中的不同的组。值得注意的是，当时还没有使用word的表格，当时ASCII时代的人，把他叫做组。

## 1.31 30 – RS – Record Separator记录分隔符

记录分隔符RS用于分隔在一个组或表内的多个记录。

## 1.32 31 – US – Unit Separator 单元分隔符

在ASCII定义中，在数据库中所存储的，最小的数据项，叫做Unit单元。而现在我们称其field域。单元分隔符US用于分割串行数据存储环境下的不同的域。现在大部分的数据库实现，要求大部分类型都拥有固定的长度。尽管大部分时候可能用不到，但是对于每一个域，却都要分配足够大的空间，用于存放最大可能的成员变量。这样的做法，占用了大量的存储空间，而US控制码允许域具有可变的长度。在1960s年代，数据存储空间很有限，用US这个单元分隔符，将不同单元分隔开，这样就可以实现更高效地存储那些宝贵的数据。另一方面，串行存储的存储效率，远低于RAM和磁盘中所实现的表格存储。

## 1.33 32 – SP – White Space 空格键

## 1.34 127 – DEL – DELete 删除

有人也许会问，为何ASCII字符集中的控制字符的值都是很小的，即0-32，而DEL控制字符的值却很大，是127。这是由于这个特殊的字符是为纸带而定义的。而在那个时候，绝大多数的纸带，都是用7个孔洞去编码数据的。而127这个值所对应的二进制值为111 1111b，表示所有7个比特位都是高，所以，将DEL用在现存的纸带上时，所有的洞就都被穿孔了，就把已经存在的数据都擦出掉了，就起到了对应的删除的作用了。