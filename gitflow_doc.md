# Git基本操作

这里只介绍部分操作，更多git的操作参考[廖雪峰的教程](https://www.liaoxuefeng.com/wiki/896043488029600)。适用于单人本地以及**单人本地远程1对1操作**。本地与远程进行同步推拉(Push,Pull)

## 本地操作：
```shell
git init #在一个文件夹下初始化git
git add #将更新过的文件添加到git缓存中
git commit #将添加到缓存中的更新提交到分支中
git branch #在当前分支创建新的分支
git checkout #切换到指定分支
git clone #从某个远程网站克隆一个项目到当前工作路径，url指远程仓库的地址
git pull #远程拉取镜像,remote指远程仓库名，branch指要下载的分支名
git push #将本地分支上传到远程分支
git merge #分支合并
```

## 远程操作
在Gitea web平台上，该项目远程仓库上的重要操作：
- Fork：将看中的仓库拉到自己的远程仓库中，由开发者执行
- Pull request：简写成PR，发送子分支合并请求，等待审核(Code Review)，由开发者执行
- Merge request ： 同意合并请求, 由审核者执行

## Tips
- 本地库也开develop分支，这样推送的时候git会匹配分支，将本地的develop推送到远程镜像的develop

- 远程仓库可以在仓库Settings页面中Branches里面设置develop为默认展示分支
![示例](./images/web端repo设置默认分支.png)

- 设置分支上游 git push --set-upstream origin {{REMOTE_BRANCH_NAME}} e.g. 本地分支切换到develop后 git push --set-upstream origin develop, 本地分支与远程分支名称保持一致。

# GitFlow简介

GitFlow工作流定义了一个围绕项目发布的严格分支模型，它为不同的分支分配了明确的角色，并定义分支之间何时以及如何进行交互。[视频简介](https://www.bilibili.com/video/av32573821/)。适用于**多人操作一个共享仓库的情况**，小范围协作。

## 分支简介

GitFlow主要包含了以下分支：
1. **master分支**：存储正式发布的产品，master分支上的产品要求随时处于可部署状态。master分支只能通过与其他分支合并请求PR来更新内容，禁止直接在master分支进行修改。
2. **develop分支**：汇总开发者完成的工作成果，develop分支上的产品可以是缺失功能模块的半成品，但是已有的功能模块不能是半成品。develop分支只能通过与其他分支合并来更新内容，禁止直接在develop分支进行修改。
3. **feature分支**：当要开发新功能或者试验新功能时，从develop分支创建一个新的feature分支，并在feature分支上进行开发。开发完成后，需要将该feature分支合并到develop分支，最后删除该feature分支。
4. **release分支**：当develop分支上的项目准备发布时，从develop分支上创建一个新的release分支，新建的release分支只能进行质量测试、bug修复、文档生成等面向发布的任务，不能再添加功能。这一系列发布任务完成后，需要将release分支合并到master分支上，并根据版本号为master分支添加tag，然后将release分支创建以来的修改合并回develop分支，最后删除release分支。
5. **hotfix分支**：当master分支中的产品出现需要立即修复的bug时，从master分支上创建一个新的hotfix分支，并在hotfix分支上进行bug修复。修复完成后，需要将hotfix分支合并到master分支和develop分支，并为master分支添加新的版本号tag，最后删除hotfix分支。
![示例](./images/gitflow工作流.png)

## GitFlow流程示范

完整的GitFlow分支适用于中大项目，这里只用两个分支做示范：master，develop。

下面用两个账号做示范，一个账号Checker是项目的创建者和审核者（对应于左图）,一个用户wangbo是开发人员（对应于右图）

主要步骤如下，其中双箭头=>表示服务器上repo之间的信息流，通过web按钮实现, 单箭头为本地到服务器之间的信息流：
1. **Init 项目组创建项目**.  Checker/proj. ，由Checker完成，创建项目主仓库Checker/proj，并默认master分支。
2. **Develop 开发者fork项目并开发**. Checker/proj/develop => wangbo/proj/develop <-> wangbo's proj/develop.

   1. 由wangbo fork主仓库到wangbo对该项目的远程镜像仓wangbo/proj，落在git服务器wangbo帐号下，然后wangbo clone到本地仓wangbo's proj。
   2. 创建develop分支。王博后续的开发都是基于本地的develop和远程的镜像仓协同开发。
   3. wangbo应实时拉去主仓库，并和本地合并，保持最新状态。

3. **Merge 审核者审核并合并项目**. wangbo/proj/develop => Checker/proj/develop wangbo远程仓ready后. 合并分支，开发者wangbo请求合并自己的远程仓的develop分支到主仓库的develop分支，Checker审核通过
4. **Release 审核者发布版本**. Checker/proj/develop => Checker/proj/master. 审核者Checker根据需求发布，把主仓库develop merge到master，并根据情况打tag

### 1.创建项目

>>1. 项目启动后，Checker在git服务器上创建一个仓库test_project，这个仓库称为"主仓库"，如下图
![](./images/创建仓库成功.png)
>>2. Checker在自己的本地电脑上某文件下初始化git，代码如下：
```python
    #创建项目文件夹，并进入
    mkdir Checker && cd Checker
    #初始化git仓库
    git init
    #新建readme.txt文件并输入内容
    touch readme.txt && echo "create a branch called master">readme.txt
    #添加一个readme.txt到git缓存区
    git add readme.txt
    #将缓存区的内容提交，这时会创建一个分支，因为是第一次commit，会默认创建一个master分支，并切换到master分支，以后每次进入这个目录，都会默认进入master分支
    git commit -m "创建了master分支"
    #这一步是为了给远程仓库创建一个别名，替代冗长的地址
    git remote add repo/test_project https://git.qingtong123.com/Checker/test_project.git
    #将本地的master分支推送到别名为'Main_Project'的远程仓库的master分支上（这个时候远程仓库并没有master分支，会自动创建），其中第一个master指本地分支，第二个master指远程分支
    git push repo/test_project master:master
```
这时刷新远程仓库可以看到已经多了一个develop分支了,如图
![](./images/push_master成功.png)

### 2.fork 项目并进行开发

>>1. wangbo在服务器上fork项目到自己的仓库（相当于拷贝项目到自己的仓库）
![](.\images\如何fork.png)
>>2. wangbo从自己的仓库clone项目到本地，代码如下：
```python
    #创建项目文件夹，并进入，
    mkdir test_project && cd test_project
    #这一步是为了给远程仓库创建一个别名，替代冗长的地址
    git remote add repo/test_project/wangbo https://git.qingtong123.com/Checker/Main_Project.git
    #将别名为'Branch_project'的远程仓库的develop分支上，拉取到本地develop分支上（如果本地没有则会自动创建），这里第一个develop为远程分支，第二个develop为本地分支4
    git pull repo/test_project/wangbo master
    #在当前分支下创建develop分支并从当前分支切换到develop分支
    git branch develop && git checkout develop
    #添加develop分支中的内容,并推送到远程仓库
    touch develop.txt && echo "create branch called develop under master branch">develop.txt
    git add develop.txt
    git commit -m "在master分支下创建了develop分支"
    #将本地的develop分支推送到远程develop分支，远程没有，会自动创建
    git push repo/test_project/wangbo develop:develop
```
这时刷新wangbo的远程仓库可以看到已经多了一个develop分支了,如图
![](./images/develop分支push成功.png)

### 3. 合并分支

这时wangbo的远程仓库已经多了一个develop分支了，现在把它合并到主仓库的master分支上
>>1. wangbo在自己的远程仓库主页面点击"合并请求"->"创建合并请求"，选择合并的子分支和主分支，填写合并请求，等待Checker审核通过，期间也可以看到别人对提交分支的评论。这一步就是Pull Request，简称PR。
![](./images/合并请求.png)
![](./image/合并请求2.png)
>>2. Checker在自己的仓库看到合并请求选项，点进去查看具体合并项，并merge（通过合并），这一步就是code_review。
![](./images/审核请求.png)

&emsp;到此就算是一个小的开发流程了，后续开发者需要不断的从develop分支pull最新版本到本地，完成开发后，push到自己fork的远程仓库某分支上，然后PR(请求合并)，大致就是在重复第二三步的操作
