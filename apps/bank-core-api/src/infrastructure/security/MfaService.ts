export interface MfaChallenge {
  challengeId: string;
  userId: string;
  expiresAt: Date;
  verified: boolean;
}

export class MfaService {
  createChallenge(userId: string): MfaChallenge {
    return {
      challengeId: crypto.randomUUID(),
      userId,
      expiresAt: new Date(Date.now() + 5 * 60 * 1000),
      verified: false,
    };
  }
}
