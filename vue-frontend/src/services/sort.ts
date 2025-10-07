type User = {
    email: string;
    [key: string]: any;
};

function quickSort(array:User[]): User[] {
    if (array.length <= 1) {
        return array;
    }

    const randomIndex = Math.floor(Math.random() * array.length);
    const randomUser = array[randomIndex];

    const rest = array.filter((_, index) => index !== randomIndex);

    const left = rest.filter(
        (item) => item.email.toLowerCase() < randomUser.email.toLowerCase()
    );

    const right = rest.filter(
        (item) => item.email.toLowerCase() >= randomUser.email.toLowerCase()
    );

    return [...quickSort(left), randomUser, ...quickSort(right)]
}

export default quickSort