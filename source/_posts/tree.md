---
title: 树
date: 2020-02-02 12:14:38
tags:
  - 算法与数据结构
  - 树
---
## 树(Tree)
### 基本概念
- 介绍
  > 树(Tree)是基础数据结构的一种, 树中的每一个元素称作节点,节点与节点之间有兄弟节点,父子节点这两种。兄弟节点之间不直接相连。我们把没有子节点的节点叫做叶子节点。
- 节点的高度
  > 节点到叶子节点最长的路径(边数)
- 节点的深度
  >节点到根节点所经历的边的个数
- 节点的层数
  > `节点的深度+1` 因为根节点的层数是1。
- 树的高度
  > 根节点的高度,或者其他节点的节点高度和节点深度之和。

  ![来源：极客时间-数据结构之美专题](http://blogimage.lemonlife.top/202002021232_96.png?/)

### 二叉树(Binary Tree)
- 介绍
  > 树的每个节点最多含有两个子节点。分别是左节点和右节点，并不要求每个节点都含有左右节点，有的节点只有左节点，有的节点只有右节

  ![来源：极客时间-数据结构算法之美](http://blogimage.lemonlife.top/202002021248_678.png?/)
- 满二叉树
  > 叶子节点都在树的最底层;且除了叶子节点外,其他节点都有左右两个子节点。

  ![来源：极客时间-数据结构算法之美](http://blogimage.lemonlife.top/202002021249_40.png?/)
- 完全二叉树
   > 叶子节点在最后两层，最后一层的叶子节点都靠左并且除了最后一层其他层构成满二叉树。
   ![来源：极客时间-数据结构算法之美](http://blogimage.lemonlife.top/202002021252_81.png?/)
#### 二叉树的储存
    树作为一种基础的数据结构,存储方式有直观的 链式储存 和用 数组存储 两种。
    1. 链式存储法,每个节点有三个字段,其中一个储存数据,另外两个分别指向左右两个节点。
    2. 数组的顺序存储法,是把跟节点存在下标 i=1 的位置(i=0暂时为空)。把i节点左节点存在2*i的位置,右节点存在2*i+1的位置。这一存储方式比较适合满二叉树和完全二叉树。用于其他类型的容易造成空间的浪费。

  ![链式存储法](http://blogimage.lemonlife.top/202002031112_287.png?/)
  ![数组的顺序存储法](http://blogimage.lemonlife.top/202002031118_599.png?/)
#### 二叉树遍历
- 前序遍历
  > 对于某个节点先遍历这个节点,再遍历左节点，最后遍历右节点。
- 中序遍历
  > 先遍历左节点再遍历这个节点本身，最后遍历有节点
- 后序遍历
  > 先遍历左节点再遍历右节点,最后遍历这个节点本身。

  ![来源：极客时间-数据结构算法之美](http://blogimage.lemonlife.top/202002021348_774.png?/)
 
 **递归模式遍历**

  前序遍历的递推公式：
  ```Java
  void preOrder(Node* root) { 
    if (root == null) return;
     print root // 此处为伪代码，表示打印 root 节点 
     preOrder(root->left); 
     preOrder(root->right);  
  }
  ```
  中序遍历的递推公式：
  ```Java
  void inOrder(Node* root) { 
    if (root == null) return; 
    inOrder(root->left);
    print root // 此处为伪代码，表示打印 root 节点 
    inOrder(root->right);
  }
  ```
  后序遍历的递推公式：
  ```Java
  void postOrder(Node* root) { 
    if (root == null) return; 
    postOrder(root->left); 
    postOrder(root->right); 
    print root // 此处为伪代码，表示打印 root 节点
  }
  ```

  **迭代模式遍历**
  ```
  ```
### 二叉查找树(Binary Search Tree)
  >二叉查找树要求,在树的任意一个节点,在其左节点的值都要小于该节点的值,在其右节点的值都要大于该节点的值,因此二叉查找树实现快速查找,并且还支持数据的快速插入或删除。
  - 查找过程
     
    先和根节点比较,如果要查找的值小于根节点则在左子树中查找,否则在右子树中查找依此类推。
    ```Java
    public class SearchTree {
      public static class Node{
          private int data;
          private Node left;
          private Node right;
          public Node(int data){
              this.data = data;
          }
      }
      private Node tree;
      public Node find(int data){
          Node t = tree;
          while (t!=null){
              if(data<t.data){
                  t=t.left;
              } else if(data>t.data) {
                  t=t.right;
              } else {
                return t;
              }
          }
          return null;
      }
    }
    ```
    ![二叉查找树查找过程](http://blogimage.lemonlife.top/202002021921_337.png?/)
  - 插入过程
    > 二叉查找树新插入的数据一般在叶子节点上,从根节点开始,如果要插入的数比节点数据小并且节点左子树为空，则将新插入的数据放到该节点左子节点的位置。如果左子树不为空依次递归遍历左子树。同样如果要插入的数据大于节点数据。对节点的右子树同样操作即可。
    ```Java
    public void insert(int data,Node tree){
    Node indexNode = tree;
    while(indexNode != null){
        if(data >= indexNode.data){
            if(indexNode.right == null){
                indexNode.right = new Node(data);
                return;
            }
            indexNode = indexNode.right;
        } else if(data<indexNode.data) {
            if(indexNode.left == null){
                indexNode.left == new Node(data);
                return;
            }
            indexNode = indexNode.left;
         }
      }
    }
    ```
      ![插入](http://blogimage.lemonlife.top/202002021953_674.png?/)

  - 删除过程
   > 二叉查找树删除过程相对于查找和插入来说比较麻烦。有三种情况
     ![](http://blogimage.lemonlife.top/202002022219_211.png?/)
     1. 如果要删除节点没有子节点我们只需要直接将父节点中指向该节点的指针指向`null`即可。比如删除图中节点55。<br/>
     2. 如果要删除的节点有一个节点(一个左节点或者一个右节点)，只需要将父节点的指针指向要删除节点的子节点即可。比如删除图中节点13<br/>
     3. 如果要删除的节点含有两个子节点。我们找到该节点的右子树中最小的节点。把他替换到要删除的节点上。比如删除图中节点18
    
  ```Java
    ///这部分感觉教程上代码有问题 先欠着以后补上。
  ```
#### 二叉查找树时间复杂度分析
  >二叉查找树执行查找的效率和数的高度成正比O(height),因此树的形状(树的左右平衡程度有关)会影响查询时间。<br/>
    1. 最坏的程度一棵树可以退化成链表查,一个含有n个节点的树,树的高度就是n。找时间复杂度为 `O(n)` <br/>
    2. 当二叉树的平衡情况最好时(满二叉树或者平衡二叉树)。一个含有n个节点的树高度为 $log_2n$<br/>
    n=$2^0+2^1+2^2+\cdots+2^{L-1}=2^L-1$ (L代表树的高度)</br>
   查找的时间复杂度为O($log_2n$)
   
  ![二叉查找树的情况](http://blogimage.lemonlife.top/202002031131_882.png?/)  

>文章中图片和部分文字代码片段来源 `极客时间-数据结构与算法之美`