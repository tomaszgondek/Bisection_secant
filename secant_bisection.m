%BEGIN
clear; clc;
%user input for limits 
lim(1) = input('Lower limit: ');
fprintf("\n");
lim(2) = input('Upper limit: ');
fprintf("\n");
syms x;
fun1 = @(x)30*(sin(x))-1; %function to evaluate

%SYMBOLLIC

disp('The function is ') %analytical solution using matlab commands
disp(fun1);
c = solve(fun1, x);
c = double(c);
disp('Roots: ');
disp(c);

fplot(fun1); %plot of the function  
hold on
xlim([c(1)-10, c(2)+10])
xlabel('x');
ylabel('y')
grid on;

%input for maximum number of operations, made for safety if the algorythm
%could not find the solution within given error
n = input('enter maximum number of iterations (for bisection and secant): ');

%BISECTION METHOD
disp('---BISECTION---')
counter = 1;
error = 0.01; %max error, +/-
derror = 0-error;
uerror = 0+error;

for i=1:n
    c1 = (lim(1)+lim(2))/2;  %standard bisection algorythm
    fc = fun1(c1);
    fa = fun1(lim(1));
    mfca = fc * fa;
    if (derror < fc) && (fc < uerror)
        disp('The solution found at: ');
        disp(c1);
        disp('Number of iterations: ');
        disp(counter);
        break;
                
    end
    if mfca < 0
        lim(2) = c1;
    else
        lim(1) = c1;
    end
    counter = counter + 1;
end

%SECANT
disp('---SECANT---') %standard secant algorythm
lim2 = lim; 
xk = lim2(1);
xk1 = lim2(2);
counter2 = 1;
for i=1:n
    fxk = double(subs(fun1, xk));
    fxk1 = double(subs(fun1, xk1));
    temp = xk - ((xk - xk1)/(fxk - fxk1)) * fxk;
    pk(i) = xk; %saving points for each iteration to create line equations later
    pk1(i) = xk1;
    pfk(i) = fxk;
    pfk1(i) = fxk1;
    xk1 = temp;
    stp = abs(fxk1);
    if  stp < error
        disp('Solution found at: ');
        disp(xk);
        disp('number of iterations: ');
        disp(counter2)
        break
    end
    counter2 = counter2+1;
end
%plotting secant lines
for i = 1:counter2
    coefficients = polyfit([pk(i) pk1(i)], [pfk(i) pfk1(i)], 1);
    a(i) = coefficients(1); 
    %getting a and b for unique equations y = a*x+b for each iteration
    b(i) = coefficients(2);        
end
for i=1:counter2
    y{i} = a(i)*x+b(i); %creating array of symbollic functions (line equations)
end
for i=1:counter2
    fplot(y{i}); %plotting each line
end
yline(0); %ploting y = 0 to enhance visibility of x axis
hold off;
%END

