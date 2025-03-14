import { Antagonist, Category } from '../base';

const Abductor: Antagonist = {
  key: 'abductor',
  name: 'Абдуктор',
  description: [
    `
      Похитители - это технологически развитое инопланетное общество, занимающееся каталогизацией
      всех видов в системе. К сожалению для их подданных, их методы
      довольно агрессивны.
    `,

    `
      Вы с напарником станете дуэтом ученых-похитителей и агентов.
      В качестве агента похищайте скромных жертв и доставляйте их обратно на свой НЛО.
      В качестве ученого ищите жертв для своего агента, обеспечивайте их безопасность и
      оперируйте тех, кого они доставят обратно.
    `,
  ],
  category: Category.Midround,
};

export default Abductor;
