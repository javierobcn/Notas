# Resumen

## Variables

### Ámbito

Por defecto el ámbito de las variables es global y todo se pasa por referencia a ámbitos descendientes y herederos.

En el siguiente ej. vemos como la variable i es sobreescrita dentro de la función al ser pasada como referencia. Ambas i, dentro y fuera de la función es la misma referencia.

```javascript
i = "global"; // es equivalente a var i = global;
function foo() {
    i = "local";
    console.log(i); // local
}
foo();
console.log(i); // local
```

### Var

Sin embargo si declaramos dentro de la función con var, se crea una variable local cuya visibilidad se reduce a la propia función:

```javascript
var i = "global";
function foo() {
    var i = "local"; // Otra variable local solo para esta función
    console.log(i); // local
}
foo();
console.log(i); // global
```

En resumen, la declaración con var define una variable en el ámbito local actual (lease función) y se hereda a scopes descendientes por referencia. Si la variable es declarada fuera de una función, la variable será una variable global.

#### Hoisting

Además del ámbito de aplicación visto antes, una variable declarada con var es sometida a hoisting ("izamiento" o "levantamiento"): la declaración de la variable es "levantada" hasta el inicio del ámbito de aplicación pero la asignación al valor permanece en el sitio donde se realice.

```javascript
console.log(i); // undefined
var i = 1;
```

el código anterior es similar a:

```javascript
var i; // Variable declarada pero valor no definido
console.log(i); // undefined
i = 1;
console.log(i); // 1
```

Sin embargo, si la variable no es declarada en absoluto obtendremos un ReferenceError, que no es lo mismo que obtener un valor indefinido:

```javascript
console.log(x); // ReferenceError: x is not defined
var i = 1;
```

### let

Un bloque en JavaScript se puede entender como «lo que queda entre dos corchetes», ya sean definiciones de funciones o bloques if, while, for y loops similares. Si una variable es declarada con let en el ámbito global o en el de una función, la variable pertenecerá al ámbito global o al ámbito de la función respectivamente, de forma similar a como ocurría con var.

Pero si declaramos una variable con let dentro un bloque que a su vez está dentro de una función, la variable pertenece solo a ese bloque:

```javascript
function foo() {
    let i = 0;
    if(true) {
        let i = 1; // Sería otra variable i solo para el bloque if
        console.log(i); // 1
    }
    console.log(i); // 0
}
foo();
```

Fuera del bloque donde se delcara con let, la variable no está definida:

```javascript
function foo() {
    if(true) {
        let i = 1;
    }
    console.log(i); // ReferenceError: i is not defined
}
foo();
```

Debido a este comportamiento, muchos desarrolladores se inclinan hacia let como la forma predeterminada de declarar variables en JavaScript y abandonar var, pues el scope más específico previene la sobreescritura de variables de forma accidental al declarar variables sin ensuciar el scope superior.

https://medium.com/craft-academy/javascript-variables-should-you-use-let-var-or-const-394f7645c88f

https://medium.com/javascript-scene/javascript-es6-var-let-or-const-ba58b8dcde75

https://hackernoon.com/js-var-let-or-const-67e51dbb716f

### const

El ámbito o scope para una variable declarada con const es, al igual que con let, el bloque, pero si la declaración con let previene la sobreescritura de variables, const directamente prohíbe la reasignación de valores (const viene de constant).

Con let una variable puede ser reasignada:

```javascript
function foo() {
    let i = 0;
    if(true) {
        i = 1;
     }
     console.log(i); // 1
}
foo();
```

Con const no es posible; si se intenta reasignar una variable constante se obtendrá un error tipo TypeError:

```javascript
const i = 0;
i = 1; // TypeError: Assignment to constant variable
```

Las variables declaradas con const son constantes (no reasignables) pero pueden ser mutables. Si es un objeto, incluso se podrían crear nuevas propiedades:

```javascript
const user = { name: 'Juan' };
user.surname = 'Pedal';
console.log(user); // {name: 'Juan', surname: 'Pedal'}
```

En general, let sería todo lo que se necesita dentro de un bloque, función o ámbito global. const sería para variables que no van sufrir una reasignación. var se puede relegar para cuando necesitemos hacer hoisting, vamos, casi nunca.
