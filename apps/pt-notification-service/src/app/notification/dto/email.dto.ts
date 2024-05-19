import { EmailProvider } from "../../interfaces/providers"

export interface NewEmail {
    primaryEmailProvider: EmailProvider,
    fallbackEmailProvider: EmailProvider,
    emailRequest: {
        from: string,
        to: string,
        subject: string,
        html: string
    }
}