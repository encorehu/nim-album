# a simple html server
import
  jester, asyncdispatch, htmlgen

import os
import times
import strutils
import mimetypes

include "main.tmpl"

const DEFAULT_CONTENT_TYPE = "text/html; charset=utf-8"
const LINE = "------------------------"
const AUTHOR = "糊糊"

let mimedb = newMimetypes()

routes:
  get "/":
    let headers = {"Content-type": "text/html; charset=utf-8"}
    var html = ""
    html.add """
    <header class="am-topbar am-topbar-fixed-top">
    <h1 class="am-topbar-brand">
        <a href="#">Album</a>
    </h1>
    <button class="am-topbar-btn am-topbar-toggle am-btn am-btn-sm am-btn-success am-show-sm-only"
            data-am-collapse="{target: '#doc-topbar-collapse'}"><span class="am-sr-only">导航切换</span> <span
            class="am-icon-bars"></span></button>

    <div class="am-collapse am-topbar-collapse" id="doc-topbar-collapse">
        <ul class="am-nav am-nav-pills am-topbar-nav">
            <li class="am-active"><a href="/list">首页</a></li>
            <li><a href="/upload">上传</a></li>

        </ul>
    </div>
</header>
<div class="imgsparent" style="position: relative;margin: 50px;">
        <style>
            .imgdiv{
                position: absolute;
                border: solid 1px #D8D8D8;
                -webkit-transition: all .7s ease-out .1s;
                -moz-transition: all .7s ease-out;
                -o-transition: all .7s ease-out .1s;
                transition: all .7s ease-out .1s

                float:left;
            }
            .imgdiv img{
                width: 250px;
            }
        </style>
        """
    var length = "public/".len
    for file in walkFiles("public/upfiles/*.*"):
      #html.add "<li>" & file[length..^1].replace("\\","/") & "</li>"
      var filepath = file[length..^1].replace("\\","/")
      html.add """
          <div class="imgdiv" id="$1">
                  <img
                      src="views?id=$2"
                      class="am-img-responsive am-radius">
                  <h3 class="am-thumbnail-caption am-text-truncate am-text-center">$3</h3>

          </div>
      """  % [filepath,filepath,filepath]
    html.add """
    </div>

<script>
    /*
     原理：1.把所有的li的高度值放到数组里面
     2.第一行的top都为0
     3.计算高度值最小的值是哪个li
     4.把接下来的li放到那个li的下面
     作者：刘晓帆
     博客地址：[url]http://liuxiaofan.com[/url]
     编写时间：2012年6月9日
     */
    var margin =20;//这里设置间距
    var par=$(".imgsparent");//这里是区块名称
    var li=$(".imgdiv");//这里是区块名称
    var	li_W = 250+margin;//取区块的实际宽度（包含间距，这里使用源生的offsetWidth函数，不适用jQuery的width()函数是因为它不能取得实际宽度，例如元素内有pandding就不行了）
    function autoresize(){//定义成函数便于调用
        var h=[];//记录区块高度的数组
        var n = document.documentElement.offsetWidth/li_W|0;//窗口的宽度除以区块宽度就是一行能放几个区块
        for(var i = 0;i < li.length;i++) {//有多少个li就循环多少次
            li_H = li[i].offsetHeight;//获取每个li的高度
            if(i < n) {//n是一行最多的li，所以小于n就是第一行了
                h[i]=li_H;//把每个li放到数组里面
                li.eq(i).css("top",0);//第一行的Li的top值为0
                li.eq(i).css("left",i * li_W);//第i个li的左坐标就是i*li的宽度
            }
            else{
                min_H =Math.min.apply(null,h) ;//取得数组中的最小值，区块中高度值最小的那个
                minKey = getarraykey(h, min_H);//最小的值对应的指针
                h[minKey] += li_H+margin ;//加上新高度后更新高度值
                li.eq(i).css("top",min_H+margin);//先得到高度最小的Li，然后把接下来的li放到它的下面
                li.eq(i).css("left",minKey * li_W);	//第i个li的左坐标就是i*li的宽度
            }

        }
        par.css("height",Math.max.apply(null,h))
    }
    /* 使用for in运算返回数组中某一值的对应项数(比如算出最小的高度值是数组里面的第几个) */
    function getarraykey(s, v) {for(k in s) {if(s[k] == v) {return k;}}}
    /*这里一定要用onload，因为图片不加载完就不知道高度值*/
    window.onload = function() {autoresize();};
    /*浏览器窗口改变时也运行函数*/
    window.onresize = function() {autoresize();};
</script>
"""
    let data = generateHTMLPage("主页", html)
    resp data, DEFAULT_CONTENT_TYPE
  get "/lounge":
    let data = generateHTMLPage("主页", h1("lounge page"))
    resp data, DEFAULT_CONTENT_TYPE
  get "/room":
    resp h1("room page"), DEFAULT_CONTENT_TYPE
  get "/create_room":
    resp h1("create room page")
  get "/json":
    resp """{"v":"2.0","update":"1450873671.4858","limit":"5","name":"\u540c\u5fd7\u4eec\u3002","host":"d65a34a4b1350e3698f0a31c41bb0739","language":"zh-CN","game":"NO","users":[{"name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","id":"d65a34a4b1350e3698f0a31c41bb0739","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","update":"1450873671"},{"name":"\u96ea\u83ef\u2749","id":"0bf9c4103788ffd77c700332011db32f","icon":"san-2x ","tripcode":{},"update":"1450873654"},{"name":"Jack Lee","id":"f35aa9f3b9bbbd589775bfa8565d74ca","icon":"zaika-2x ","tripcode":{},"update":"1450873347"},{"name":"usererr","id":"91ab94483a6fdb7350622f33faa365d5","icon":"eight ","tripcode":{},"update":"1450873647"}],"talks":[{"id":"baaf27350be738a3f731fbf41fd8350b","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u4e0d","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450872941"},{"id":"96eb40097b42aa6362e0e2c2c056137e","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u6682\u65f6\u5b85","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450872947"},{"id":"9f482d8787935296b0edbf30ad6e31b4","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u591a\u51fa\u53bb\u8d70\u8d70","icon":"san-2x ","tripcode":{},"type":"message","time":"1450872957"},{"id":"ec66dc5d71da6947b1721135fbbd07b9","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u5468\u672b\u51fa\u53bb\u8dd1\u8dd1\u6b65\u554a","icon":"san-2x ","tripcode":{},"type":"message","time":"1450872965"},{"id":"17c32f7ab5d96235951c20863b1fd03e","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u591a\u505a\u70b9\u6709\u6c27\u8fd0\u52a8","icon":"san-2x ","tripcode":{},"type":"message","time":"1450872969"},{"id":"0037dae9f456b718bb93988babf53d90","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u4e45\u5750\u90fd\u4f1a\u80be\u865a","icon":"san-2x ","tripcode":{},"type":"message","time":"1450872976"},{"id":"fb110d336676967935de63a78459f5eb","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u6211\u5929\u5929\u8fd0\u52a8\u7684","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450872979"},{"id":"2c03d27317f30d5b453c2a9c1618e76f","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u5668\u68b0\u90fd\u6709","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450872998"},{"id":"d9fa673626556d9bb04fc9f4959981f2","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"um..\u90a3\u5927\u6982\u6211\u60f3\u9519\u4e86","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873018"},{"id":"8313c21b8d49378bbbde763d980c87ff","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u3002\u3002\u3002","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873026"},{"id":"f7b5251768716410e14a816518abbbf7","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u5927\u591a\u6570\u80be\u865a\u7684\u7537\u7684\u90fd\u662f\u4e45\u5750(","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873059"},{"id":"fadc2bc7e3381ec32a87c06f547c57d8","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u55ef","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873080"},{"id":"b9911529b5ba17ee9ccff8198557d2f1","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u5403\u70b9\u4e2d\u836f\u8c03\u7406\u4e0b\u5c31\u597d\u4e86","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873089"},{"id":"d1d0e603835da991b35beecdadc46380","uid":"d65a34a4b1350e3698f0a31c41bb0739","name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","message":"\u6ca1\u5173\u7cfb\u5566\uff0c\u52a0\u6cb9\u2026\u2026","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","type":"message","time":"1450873098"},{"id":"c69b6b76596d2dadddac4d6dd6878c60","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u55ef \u597d\u7684","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873104"},{"id":"f27c3f9cb2800a7ee2da77372918bf14","uid":"d65a34a4b1350e3698f0a31c41bb0739","name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","message":"(\u62cd\u62cd\u80a9(\u0e07 \u2022\u0300_\u2022\u0301)\u0e07","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","type":"message","time":"1450873115"},{"id":"1b18491b21be4b2cd80c947488a1e962","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"(\u5176\u5b9e\u4e0d\u7b97\u4ec0\u4e48\u4e8b","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873123"},{"id":"54a41fe64fb6ff31a4c02d8d202cbda1","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u7537\u7684\u5c31\u6ca1\u51e0\u4e2a\u6562\u8bf4\u81ea\u5df1\u80be\u5f88\u597d\u7684(","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873130"},{"id":"7180b0aa9217cdf330a83ea96e1615e8","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u3002\u3002\u3002\u3002","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873137"},{"id":"50f748f756f830af78239bf479fb6f8a","uid":"d65a34a4b1350e3698f0a31c41bb0739","name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","message":"\u5c31\u662f","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","type":"message","time":"1450873140"},{"id":"9a8fbf81b602beb69240be7a8c830fcd","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u4f60\u4fe9\u4eca\u5929\u89c1\u4e00\u4e2a \u4f9d\u9e1f \u7684\u4eba\u6ca1","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873272"},{"id":"0cfe80f71547eb360f627ba887b89dca","uid":"d65a34a4b1350e3698f0a31c41bb0739","name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","message":"\u6ca1\u6709\u8bf6","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","type":"message","time":"1450873288"},{"id":"fbe7317ea04a5323141497f1d440a206","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u5594","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873296"},{"id":"aa67e0e73ea94107eeccd7225fc709d5","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u4f0a\u9e1f?","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873309"},{"id":"68dd21e2d1928084e2733d9565e7f6db","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u55ef","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873313"},{"id":"0585394921e75fcaf4660843e07ec16c","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u600e\u4e48\u4e86","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873318"},{"id":"5ced215f730fddff052821e93232c4a2","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u4ed6\u6765\u8fc7\uff1f","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873331"},{"id":"5f78e01f7e3931de7864d02774c1169b","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u6ca1\u6765\u554a","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873339"},{"id":"d1852e27eef94c23b45d170fd3a8cae8","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u4f60\u627e\u5979?","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873342"},{"id":"10446297820132cbbaf0222f6e2433b8","uid":"f35aa9f3b9bbbd589775bfa8565d74ca","name":"Jack Lee","message":"\u55ef","icon":"zaika-2x ","tripcode":{},"type":"message","time":"1450873347"},{"id":"9b2bc55916ada3c39132f9c240109ee8","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u5979\u56de\u5bb6\u4e86","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873354"},{"id":"4f365e7b4f4be2286196f45cf917c216","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":"\u660e\u5929\u4f1a\u4e0a\u5427","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873359"},{"id":"a4d0610a8e14656be2c2acd56a0e3365","uid":"91ab94483a6fdb7350622f33faa365d5","name":"usererr","message":"{1} logged in.","type":"login","icon":"eight ","time":"1450873647"},{"id":"43ae00ac9502bcd0309495264ac66930","uid":"0bf9c4103788ffd77c700332011db32f","name":"\u96ea\u83ef\u2749","message":".","icon":"san-2x ","tripcode":{},"type":"message","time":"1450873654"},{"id":"64277ae75964563ac940757ec02c6416","uid":"d65a34a4b1350e3698f0a31c41bb0739","name":"\u4e0d\u8e81\u4e0d\u8212\u670d\u7684\u8d1d\u65af\u624b","message":"\u55e8","icon":"setton-2x is-tripcode","tripcode":"d\/JJ0swnCU","type":"message","time":"1450873671"}],"error":"0"}"""

  get "/attachment":
    attachment "public/root/index.html"
    resp "blah"

  get "/list":
    redirect "/"

  get "/upload":
    var html = ""
    var length = "public/".len
    for file in walkFiles("public/upfiles/*.*"):
      html.add "<li>" & file[length..^1].replace("\\","/") & "</li>"
    html.add "<form action=\"upload\" method=\"post\" enctype=\"multipart/form-data\">"
    html.add "<input type=\"file\" name=\"file\" value=\"file\">"
    html.add "<input type=\"submit\" value=\"Submit\" name=\"submit\">"
    html.add "</form>"
    resp(html)

  post "/upload":
    var data = request.formData["file"].body
    var timestamp = int(toSeconds(getTime()))
    var (dir, filename, ext) = splitFile(request.formData["file"].fields["filename"])
    ext = ext.toLower # ext here is like ".PNG"
    var newfilename = addFileExt($timestamp, ext)
    writeFile("public/upfiles/" & newfilename, data)
    redirect("/upfiles/" & newfilename)

runForever()
