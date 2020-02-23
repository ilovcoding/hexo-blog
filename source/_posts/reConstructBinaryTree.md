---
title: 重建二叉树
date: 2020-02-04 17:16:40
tags:
  - 数据结构算法编程题
  - 剑指Offer
---
## 重建二叉树
> 输入某二叉树的前序遍历和中序遍历的结果，请重建出该二叉树。假设输入的前序遍历和中序遍历的结果中都不含重复的数字。例如输入前序遍历序列{1,2,4,7,3,5,6,8}和中序遍历序列{4,7,2,1,5,3,8,6}，则重建二叉树并返回。

## 分析问题
> 根据前序遍历先遍历根节点的特点,可知前序遍历的序列中前一部分可能是根节点。根据中序遍历先遍历左节点再遍历根节点的特点。在中序遍历的结果中左节点在根节点的左边。因此中序遍历中和前序遍历相等的点为根节点,节点左边可构成左子树。


## 解决问题
> 从上分析知,1为根节点1的左子树由 `4,7,2` 构成;2为根节点2的左子树由 `4,7` 构成;依次类推,易知可采用递归解决问题。
```Java
import java.util.Arrays;
public class Solution {
        public TreeNode reConstructBinaryTree(int [] pre,int [] in) {
           if(pre.length == 0){
               return null;
           }
           int rootValue = pre[0];
           TreeNode tree = new TreeNode(rootValue);
           if(pre.length ==1){
               return tree;
           }
          int rootIndex = 0;
          for(int i =0;i<in.length;i++){
              if(rootValue == in[i]){
                  rootIndex = i;
                  break;
            }
          }
        tree.left = reConstructBinaryTree(Arrays.copyOfRange(pre,1,rootIndex+1),Arrays.copyOfRange(in,0,rootIndex));
        tree.right = reConstructBinaryTree(Arrays.copyOfRange(pre,rootIndex+1,in.length),Arrays.copyOfRange(in,rootIndex+1,in.length));
        return tree;
    }
}
```


