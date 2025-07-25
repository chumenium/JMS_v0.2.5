<!--*
：：：色のテーマは緑：：：
試験・面接内容登録用画面

******教員-生徒-どちらにも表示されるページ****
******権限によって表示されるボタンが変わる****

:::権限一覧:::

{
  "teacher":           "教員",
  "headmaster": "教務部長_校長",
  "egd":      "就職指導部",
  "admin":             "管理者",
  "student":           "学生"
}

||**試験・面接内容登録**||

**

*-->

<!--KCS_JMS_PROJECT-->


<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>試験・面接内容登録</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
            <style>

            </style>
        </head>

        <body>
            <% String username=(String) session.getAttribute("username"); String role=(String)
                session.getAttribute("role"); // 権限名を日本語に変換 String roleDisplay="" ; switch(role) { case "teacher" :
                roleDisplay="教員" ; break; case "headmaster" : roleDisplay="教務部長・校長" ; break; case "egd" :
                roleDisplay="就職指導部" ; break; case "admin" : roleDisplay="システム管理者" ; break; case "student" :
                roleDisplay="学生" ; break; default: roleDisplay=role; break; } 
            %>
            <div id="container">
                <!--▼▼▼▼▼ここから「ヘッダー」-->
                <header>
                    <h1 id="logo"><a href="javascript:void(0);" onclick="location.reload();"><img src="images/logo.png" alt="jms"></a></h1>
                    <nav>
                        <ul>
                            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
                            <!-- 管理者権限のナビゲーション -->
                            <% if ("admin".equals(role)) { %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase">管理者設定</a>
                                </li>
                            <% } %>
                            <!-- 教師権限のナビゲーション -->
                            <% if ("teacher".equals(role) || "headmaster" .equals(role) || "egd".equals(role)) { %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                </li>
                            <% } %>
                            <!-- 生徒権限のナビゲーション -->
                            <% if ("student".equals(role)) { %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/InterviewExamInputServlet">試験面接情報</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a>
                                </li>
                            <% } %>
                                <li>
                                    <a href="extension.html">お問い合わせ</a>
                                </li>
                            <% if (username !=null) { %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a>
                                </li>
                            <% } %>
                        </ul>
                    </nav>
                </header>
                    <!--▲▲▲▲▲ここまで「ヘッダー」-->





























                <!--▼▼▼▼▼ここから「フッター」-->
                <footer>
                    <div>
                        <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
                        <ul class="icons">
                            <li><a href="#"><i class="fa-brands fa-x-twitter"></i></a></li>
                            <li><a href="#"><i class="fab fa-line"></i></a></li>
                            <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                            <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                        </ul>
                        <small>Copyright&copy; @ 2025 Job Management System All Rights Reserved.</small>
                    </div>
                    <div>
                        <ul>
                            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
                            <!-- 管理者権限のナビゲーション -->
                            <% if ("admin".equals(role)) { %>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">管理者設定</a>
                                </li>
                                    <% } %>
                                        <!-- 教師権限のナビゲーション -->
                                        <% if ("teacher".equals(role) || "headmaster" .equals(role) || "egd"
                                            .equals(role)) { %>
                                            <li>
                                                <a href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                            </li>
                                            <li>
                                                <a href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                            </li>
                                            <li>
                                                <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                            </li>
                                            <% } %>
                                                <!-- 生徒権限のナビゲーション -->
                                                <% if ("student".equals(role)) { %>
                                                    <li>
                                                        <a href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a>
                                                    </li>
                                                    <li>
                                                        <a href="${pageContext.request.contextPath}/InterviewExamInputServlet">試験面接情報</a>
                                                    </li>
                                                    <li>
                                                        <a href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a>
                                                    </li>
                                                    <li>
                                                        <a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a>
                                                    </li>
                                                    <% } %>
                                                        <li><a href="extension.html">お問い合わせ</a></li>
                            </ul>
                        </div>
                    </footer>
                    <!--▲▲▲▲▲ここまで「フッター」-->

                    <!--▼▼最下部-->
                    <span class="pr"><a href="" target="_blank">@ 2025 Job Management System</a></span>
                    <!--▲▲ここまで最下部-->
                </div>
                <!--/#container-->

                <!--開閉ボタン（ハンバーガーアイコン）-->
                <div id="menubar_hdr">
                    <span></span><span></span><span></span>
                </div>

                <!--開閉ブロック-->
                <div id="menubar">
                    <p class="logo"><img src="images/logo.png" alt="Job Management System"></p>
                    <nav>
                        <ul>
                            <li><a href="javascript:void(0);" onclick="location.reload();">ホーム</a></li>
                            <!-- 管理者権限のナビゲーション -->
                            <% if ("admin".equals(role)) { %>
                                <li><a
                                        href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                </li>
                                <li><a
                                        href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                </li>
                                <li><a href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                </li>
                                <li><a
                                        href="${pageContext.request.contextPath}/StatusServlet?view=adminDatabase.jsp">管理者設定</a>
                                </li>
                                <% } %>
                                    <!-- 教師権限のナビゲーション -->
                                    <% if ("teacher".equals(role) || "headmaster" .equals(role) || "egd" .equals(role))
                                        { %>
                                        <li><a
                                                href="${pageContext.request.contextPath}/StatusServlet?view=studentManagement">学生管理</a>
                                        </li>
                                        <li><a
                                                href="${pageContext.request.contextPath}/StatusServlet?view=CompanyManagement">企業管理</a>
                                        </li>
                                        <li><a
                                                href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">就職管理</a>
                                        </li>
                                        <% } %>
                                            <!-- 生徒権限のナビゲーション -->
                                            <% if ("student".equals(role)) { %>
                                                <li><a
                                                        href="${pageContext.request.contextPath}/SelectionStageServlet">選考ステージ登録</a>
                                                </li>
                                                <li><a
                                                        href="${pageContext.request.contextPath}/InterviewExamInputServlet">試験面接情報</a>
                                                </li>
                                                <li><a
                                                        href="${pageContext.request.contextPath}/CompanyListServlet">企業一覧</a>
                                                </li>
                                                <li><a
                                                        href="${pageContext.request.contextPath}/StatusServlet?view=jobHunting">書類提出チェック</a>
                                                </li>
                                                <% } %>
                                                    <li><a href="extension.html">お問い合わせ</a></li>
                                                    <% if (username !=null) { %>
                                                        <li><a
                                                                href="${pageContext.request.contextPath}/LogoutServlet">ログアウト</a>
                                                        </li>
                                                        <% } %>
                        </ul>
                    </nav>
                </div>
                <!--/#menubar-->

                <!--jQueryの読み込み-->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
                <!--パララックス（inview）-->
                <script
                    src="https://cdnjs.cloudflare.com/ajax/libs/protonet-jquery.inview/1.1.2/jquery.inview.min.js"></script>
                <script src="js/jquery.inview_set.js"></script>
                <!--このテンプレート専用のスクリプト-->
                <script src="js/main.js"></script>
            </div>
        </body>

        </html>