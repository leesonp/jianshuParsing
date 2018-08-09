//隐藏视图
function hidViews(){
    //隐藏顶部信息
    document.getElementsByClassName("header-wrap")[0].style.display = "none";
    //隐藏“打开APP”
    document.getElementsByClassName("app-open")[0].style.display = "none";
    //隐藏打开简书APP按钮
    document.getElementsByClassName("open-app-btn")[0].style.display = "none";
    //隐藏底部
    document.getElementById("footer").style.display = "none";
    //隐藏喜欢按钮
    document.getElementsByClassName("like-btn")[0].style.display = "none";
    //输出正文内容
    let mainBody = document.getElementsByClassName("collapse-free-content")[0].outerHTML
    window.webkit.messageHandlers.hidViews.postMessage(mainBody);
};
hidViews();

//移除头部作者信息的href属性(想禁止a标签的跳转，无果)
//var bObj = document.getElementsByClassName("article-info")[0].getElementsByClassName("info")[0];
//bObj.href = "javascript:void(0);";
//bObj.onclick = "js_method();return false;";
//bObj.removeAttribute("href")
//覆盖
//bObj.onclick = function(e){
//    alert("跳转动作被我阻止了");
//     e.preventDefault();
//     //js_method();
//     //return false;//也可以
//}
//添加点击事件
//bObj.addEventListener("click", Myfun);
//function Myfun(evt){
//    alert(evt.clientX + "px," + evt.clientY +"px");
//    window.webkit.messageHandlers.Myfun.postMessage(666);
//}

//创建一个定位的覆盖层间 接阻止a标签的跳转
function createView(){
    var div = document.getElementsByClassName("article-info")[0];
    div.style.position = "relative";
    var childDiv = document.createElement("div");
    childDiv.id = "cover-div";
    //childDiv.style.background = "red";
    childDiv.style.position = "absolute";
    childDiv.style.top = "0";
    childDiv.style.left = "0";
    childDiv.style.right = "0";
    childDiv.style.bottom = "0";
    //childDiv.innerHTML=" i am a append div !"
    div.appendChild(childDiv);
    window.webkit.messageHandlers.createView.postMessage("Success");
}
createView();
