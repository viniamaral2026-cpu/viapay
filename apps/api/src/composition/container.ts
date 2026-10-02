import {
  CreatePayment,
  GetPayment,
  HandlePixPayment
} from "@viapay/application";

import {
  InMemoryPaymentRepository,
  FakePixProvider
} from "@viapay/infrastructure";

const paymentRepository = new InMemoryPaymentRepository();
const pixProvider = new FakePixProvider();

export const container = {
  paymentRepository,
  pixProvider,

  createPayment: new CreatePayment(
    paymentRepository,
    pixProvider
  ),

  getPayment: new GetPayment(
    paymentRepository
  ),

  handlePixPayment: new HandlePixPayment(
    paymentRepository
  )
};
