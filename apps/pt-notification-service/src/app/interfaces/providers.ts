export type EmailProvider =
  | EmailProviderSmtp
  | EmailProviderSendmail
  | EmailProviderMailgun
  | EmailProviderSendgrid
  | EmailProviderSES
  | EmailProviderSparkpost;

export interface EmailProviderSmtp {
  type: 'smtp';
  host: string;
  port: number;
  secure: boolean;
  auth: {
    user: string;
    pass: string;
  };
}

export interface EmailProviderSendmail {
  type: 'sendmail';
  sendmail: boolean;
  newline: string;
  path: string;
}

export interface EmailProviderMailgun {
  type: 'mailgun';
  apiKey: string;
  domainName: string;
}

export interface EmailProviderSendgrid {
  type: 'sendgrid';
  apiKey: string;
}

export interface EmailProviderSES {
  type: 'ses';
  region: string;
  accessKeyId: string;
  secretAccessKey: string;
  sessionToken?: string;
}

export interface EmailProviderSparkpost {
  type: 'sparkpost';
  apiKey: string;
}
