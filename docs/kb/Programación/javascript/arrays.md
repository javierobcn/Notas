# Arrays

## Definir un array

```javascript
const users = [
    {name: 'Javier', age:30},
    {name: 'juan', age:16},
    {name: 'Laura', age:30},
    {name: 'Guillermo', age:12}
];

console.log(users);

```

## Recorrer un array

```javascript
users.forEach(user => console.log(`Hello ${user.name}`));
```

## Filtrar un array

Obtiene un nuevo array con los elementos que cumplen una condición

```javascript
const mayores_de_edad = users.filter(user => user.age > 18);
```

## Buscar el primer elemento del array que cumpla una condición

```javascript
const user_30 = users.find(user => user.age === 30)
console.log(user_yo);
```

## Crear un nuevo array que contenga solo una de las llaves del array original

```javascript
const edades = users.map(user => user.age)
console.log(edades);
```

## Modificar una de las llaves del array de forma masiva

```javascript
const edades_modificadas = users.map(user => user.age - 5)
console.log(edades);
```

## No usar for para recorrer el array y operar

partimos de un array como este

```javascript
const users = [
    {name: 'Javier', age:30},
    {name: 'juan', age:16},
    {name: 'Laura', age:30},
    {name: 'Guillermo', age:12}
];

console.log(users);

```

### Alguno de los elementos cumple una condición?

```some``` chequea que **alguno** de los elementos cumpla una condición

```javascript
const hay_menores = users.some(user => user.age < 18);
console.log(hay_menores) /* True
```

### Todos los elementos cumplen una condición?

```every``` chequea que **todos** los elementos cumplan una condición

```javascript
const todos_menores = users.every(user => user.age < 18);
console.log(todos_menores) /* False */
```

### Existe un valor dentro del array?

```javascript
const frutas = ['fresa','plátano','uva','cerezas'];
const hasuva = frutas.includes('uva');
console.log(hasuva) // True 
const haspera = frutas.includes('pera');
console.log(hasuva) // False

```

### Operar con los valores en un array

```javascript
const ingresos_dia = [150,200,230,190,150,215,200];

const total_ingresos = ingresos_dia.reduce((total,income) => total += income);

console.log(total_ingresos); // 1335

```
