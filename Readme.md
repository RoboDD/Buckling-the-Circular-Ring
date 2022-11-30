# Buckling the Ring

MTH208 Numerical Analysis Coursework Project. You can find the problem and my solution. Q1~Q4 are definitely correct. Futher dicussion are welcome. 

Update: This work get 90% marks.


# Hints
Sunday, 16 May 2021, 09:50
For the item 1, you either calculate by hand or use the symbolic toolbox of Matlab. For the item 2, it is suggested to use Broyden II method. If you find the method is insufficient, you may also try Broyden I method.



Wednesday, 19 May 2021, 11:31
1. You can use the function ode45 to get accurate solution. Use https://ww2.mathworks.cn/help/ to search any command.

2. You would better put some checkpoints in your implementation of Broyden II method. After each iteration, you need to check whether the equation F(s)==0 is approximately satisfied, e.g. if norm(F(s))<1e-10, return; end; If all the iterations have been finished but the aforementioned condition has never been satisfied, then before ending the Broyden function, you can throw a message, e.g., disp(['broyden2: all iterations done, ||F(s)||=', num2str(norm(F(s)))]); such that you will know that broyden2 has not converged yet, which may be due to that the initial guess is not so good.

3. At c=0.01, p=0, you can take the initial guess [-1; 0; 0]. At c=0.01, p = 3.5, you can take the initial guess [-2; 1; 0] and [-0.5; 1; 1].

4. For other values of c and p, you may consider the continuity about c or p. The idea is that if p changes a little, then the solution may change also only a little. So, if we have found a solution at p = 3.5, then we can use the solution as a good initial guess at p = 3.51. 

To do so, you need to manipulate the value of p in a loop or so. One trick is to use the global variable. For example, in your function F for the mathematical function F(s), you can declare `global c p;' and, 

in your script where you call broyden2 to solve the problem, you can declare also `global c p;' before setting the values of c and p.




Friday, 21 May 2021, 17:37
Here is another hint. If you want to plot a circle and want the circle plotted looking like a circle, you can use the command `axis equal;'.


