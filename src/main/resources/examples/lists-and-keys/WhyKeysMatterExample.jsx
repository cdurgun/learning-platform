function WhyKeysMatterExample() {
  const tasks = [
    { id: 1, text: "Sütü al" },
    { id: 2, text: "Ekmek al" },
  ];

  // key, React'e "bu liste elemanı önceki render'daki HANGİ elemanla
  // aynı" olduğunu söyler. Bir eleman eklenip/silindiğinde ya da sıra
  // değiştiğinde React bunu kullanarak doğru elemanı günceller -- key
  // olmadan (ya da yanlış bir key ile) React yanlış elemanı güncelleyip
  // beklenmedik görsel hatalara (ör. input'un yanlış satıra kayması)
  // yol açabilir.
  return (
    <ul>
      {tasks.map((task) => (
        <li key={task.id}>{task.text}</li>
      ))}
    </ul>
  );
}
